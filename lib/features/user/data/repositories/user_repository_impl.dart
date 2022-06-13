import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_language/core/api/api_repository.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/utils.dart';
import 'package:easy_language/features/dictionaries/domain/repositories/dictionaries_repository.dart';
import 'package:easy_language/features/user/data/data_sources/user_local_data_source.dart';
import 'package:easy_language/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:easy_language/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
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

  Future _ensureInitialized() async {
    if (_initial) {
      await initUser();
    }
  }

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
      return InfoFailure(errorMessage: e.toString());
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
      return InfoFailure(errorMessage: e.toString(), showErrorMessage: false);
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
      return InfoFailure(errorMessage: e.toString());
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

      final Response response = await dio()
          .post(
        '$api/authentication/google-authentication',
        data: {'token': accToken},
        options: Options(headers: {'requiresToken': false}),
      )
          .onError((error, stackTrace) {
        googleSignIn.signOut();
        throw Exception(error);
      });

      final Map bodyMap = cast(response.data);

      if (!response.ok) {
        Logger().e(response.data);
        Logger().e(response.statusCode);
        return InfoFailure(
          errorMessage: "Couldn't register: ${bodyMap['message']}",
        );
      }

      user = UserModel.fromMap(bodyMap);
      localDataSource.cacheUser(user!);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: "Couldn't sign in.");
    }
  }

  @override
  Future<InfoFailure?> login({required Map formMap}) async {
    try {
      final response = await dio().post(
        '$api/authentication/login',
        data: jsonEncode(formMap),
        options: Options(headers: {'requiresToken': false}),
      );

      final Map bodyMap = cast(response.data);

      if (!response.ok) {
        Logger().e(response.data);
        Logger().e(response.statusCode);
        return InfoFailure(
          errorMessage: "Couldn't log in: ${bodyMap['message']}",
        );
      }

      user = UserModel.fromMap(bodyMap);
      localDataSource.cacheUser(user!);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: "Couldn't log in");
    }
  }

  @override
  Future<InfoFailure?> register({required Map formMap}) async {
    try {
      final response = await http.post(
        Uri.parse('$api/authentication/register'),
        body: jsonEncode(formMap),
        headers: headers(),
      );

      final Map bodyMap = cast(jsonDecode(response.body));

      if (!response.ok) {
        Logger().e(response.body);
        Logger().e(response.statusCode);
        return InfoFailure(
          errorMessage: "Couldn't register: ${bodyMap['message']}",
        );
      }

      user = UserModel.fromMap(bodyMap);
      localDataSource.cacheUser(user!);

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
      final String? token = user?.token;

      user = null;

      await GoogleSignIn.standard().signOut();

      localDataSource.clearUser();

      final response = await http.get(
        Uri.parse('$api/user/logout'),
        headers: headers(token),
      );

      if (!response.ok) {
        final Map bodyMap = cast(jsonDecode(response.body));
        Logger().e(response.body);
        Logger().e(response.statusCode);
        return InfoFailure(
          errorMessage: "Couldn't logout: ${bodyMap['message']}",
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

  @override
  Future<InfoFailure?> refreshToken({required String token}) async {
    if (user == null) return InfoFailure(errorMessage: 'User is null');
    user = user!.copyWithMap({User.tokenId: token});
    return null;
  }

  // TODO: remove account when it's linked with google
  @override
  Future<InfoFailure?> removeAccount({
    required String email,
    required String password,
  }) async {
    try {
      if (user == null) {
        throw 'User is null';
      }

      final response = await http.delete(
        Uri.parse('$api/user'),
        headers: headers(user!.token),
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (!response.ok) {
        throw response.body;
      }

      localDataSource.clearUser();
      user = null;

      sl<DictionariesRepository>().logout();

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: e.toString());
    }
  }
}
