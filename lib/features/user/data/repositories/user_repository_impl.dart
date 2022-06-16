import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_language/core/api/api_repository.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/dictionaries/domain/repositories/dictionaries_repository.dart';
import 'package:easy_language/features/user/data/data_sources/user_local_data_source.dart';
import 'package:easy_language/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:easy_language/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class UserRepositoryImpl implements UserRepository {
  bool _initial = true;

  @override
  UserModel? user;

  @override
  bool get loggedIn => user != null;

  final SettingsLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;
  final ApiRepository dio;

  UserRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.dio,
  });

  @override
  Future<InfoFailure?> editUser({
    required Map userMap,
  }) async {
    try {
      await _ensureInitialized();

      if (!loggedIn) {
        return InfoFailure(errorMessage: 'user not logged in');
      }

      user = await remoteDataSource.editUser(
        userToEdit: user!,
        editMap: userMap,
      );

      localDataSource.cacheUser(user!);
      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(
        errorMessage:
            'Error: could not edit a user. Check your internet connection!',
      );
    }
  }

  @override
  Future<InfoFailure?> initUser() async {
    try {
      _initial = false;
      user = await localDataSource.getCachedUser();
      await fetchUser();
      return loggedIn
          ? null
          : InfoFailure(errorMessage: 'User is not logged in (null).');
    } catch (e) {
      _initial = false;
      Logger().e(e);
      return InfoFailure(
        errorMessage:
            'Error: could not init a user. Check your internet connection!',
        showErrorMessage: false,
      );
    }
  }

  @override
  Future<InfoFailure?> fetchUser() async {
    await _ensureInitialized();

    if (!loggedIn) {
      return InfoFailure(errorMessage: 'user not logged in');
    }

    try {
      final newUser = await remoteDataSource.fetchUser(userToFetch: user!);

      if (newUser.updatedAt.isAfter(user!.updatedAt)) {
        user = newUser;
        localDataSource.cacheUser(user!);
      }

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(
        errorMessage:
            'Error: could not fetch a user. Check your internet connection!',
      );
    }
  }

  @override
  Future<InfoFailure?> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        clientId: kIsWeb ? dotenv.env[oauthClientIdWeb] : null,
      );
      final GoogleSignInAccount? gAcc = await googleSignIn.signIn();
      if (gAcc == null) {
        return InfoFailure(errorMessage: "Couldn't sign in.");
      }
      final accToken = (await gAcc.authentication).accessToken;

      final Response<Map> response = await dio()
          .post<Map>(
        '$api/authentication/google-authentication',
        data: {'token': accToken},
        options: Options(headers: {'requiresToken': false}),
      )
          .onError((error, stackTrace) {
        googleSignIn.signOut();
        throw Exception(error);
      });

      if (!response.ok) {
        Logger().e(response.data);
        Logger().e(response.statusCode);
        return InfoFailure(
          errorMessage: "Couldn't register: ${response.data?['message']}",
        );
      }

      await _handleUserResponse(response.data!);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: "Couldn't sign in.");
    }
  }

  @override
  Future<InfoFailure?> login({required Map formMap}) async {
    try {
      final Response<Map> response = await dio().post(
        '$api/authentication/login',
        data: formMap,
        options: Options(headers: {'requiresToken': false}),
      );

      if (!response.ok || response.data == null) {
        Logger().e(response.data);
        Logger().e(response.statusCode);
        return InfoFailure(
          errorMessage: "Couldn't log in: ${response.data?['message']}",
        );
      }

      await _handleUserResponse(response.data!);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: "Couldn't log in");
    }
  }

  @override
  Future<InfoFailure?> register({required Map formMap}) async {
    try {
      final Response<Map> response = await dio().post(
        '$api/authentication/register',
        data: formMap,
        options: Options(headers: {'requiresToken': false}),
      );

      if (!response.ok || response.data == null) {
        Logger().e(response.data);
        Logger().e(response.statusCode);
        return InfoFailure(
          errorMessage: "Couldn't register: ${response.data?['message']}",
        );
      }

      await _handleUserResponse(response.data!);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: "Couldn't register");
    }
  }

  @override
  Future<InfoFailure?> logout() async {
    if (!loggedIn) {
      return InfoFailure(errorMessage: 'user not logged in');
    }

    try {
      user = null;

      await GoogleSignIn.standard().signOut();

      await localDataSource.clearUser();

      final Response<Map> response = await dio().get('$api/user/logout');

      if (!response.ok) {
        Logger().e(response.data);
        Logger().e(response.statusCode);
        return InfoFailure(
          errorMessage: "Couldn't logout: ${response.data?['message']}",
          showErrorMessage: false,
        );
      }

      sl<DictionariesRepository>().logout();

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: "Couldn't register");
    }
  }

  // TODO: remove account when it's linked with google
  @override
  Future<InfoFailure?> removeAccount({
    String? email,
    String? password,
    String? googleToken,
  }) async {
    try {
      if (user == null) {
        throw 'User is null';
      }

      final Response<bool> response = await dio().delete(
        '$api/user',
        data: {
          if (email != null) 'email': email,
          if (password != null) 'password': password,
          if (googleToken != null) 'googleToken': googleToken,
        },
      );

      if (!response.ok) {
        throw response.data ?? 'No data from removeAccount response.';
      }

      await localDataSource.clearUser();
      user = null;

      sl<DictionariesRepository>().logout();

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(
        errorMessage:
            'Error: could not remove an account. Check your internet connection!',
      );
    }
  }

  // Helper methods
  Future _handleUserResponse(Map bodyMap) async {
    final String accessToken = cast(bodyMap[accessTokenId]);
    final String refreshToken = cast(bodyMap[refreshTokenId]);
    final Map userMap = cast(bodyMap['user']);

    await dio.apiBox.put(accessTokenId, accessToken);
    await dio.apiBox.put(refreshTokenId, refreshToken);
    user = UserModel.fromMap(userMap);
    await localDataSource.cacheUser(user!);
  }

  Future _ensureInitialized() async {
    if (_initial) {
      await initUser();
    }
  }
}
