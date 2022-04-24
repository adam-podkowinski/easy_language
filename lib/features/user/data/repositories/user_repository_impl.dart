import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/data/data_sources/user_local_data_source.dart';
import 'package:easy_language/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class UserRepositoryImpl implements UserRepository {
  bool _initial = true;

  UserModel? _user;

  bool get loggedIn => _user != null;

  final SettingsLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future _ensureInitialized() async {
    if (_initial) {
      await initUser();
    }
  }

  @override
  Future<Either<Failure, User>> editUser({
    required Map userMap,
  }) async {
    try {
      await _ensureInitialized();

      if (!loggedIn) {
        return Left(UserUnauthenticatedFailure('user not logged in'));
      }

      _user = await remoteDataSource.editUser(
        userToEdit: _user!,
        editMap: userMap,
      );

      localDataSource.cacheUser(_user!);
      return Right(_user!);
    } catch (_) {
      return Left(UserCacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> initUser() async {
    try {
      _initial = false;
      _user = await localDataSource.getCachedUser();
      await fetchUser();
      return loggedIn ? Right(_user!) : Left(UserGetFailure());
    } catch (_) {
      _initial = false;
      return Left(UserGetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> fetchUser() async {
    await _ensureInitialized();

    if (!loggedIn) {
      return Left(UserUnauthenticatedFailure('user not logged in'));
    }

    try {
      final newUser = await remoteDataSource.fetchUser(userToFetch: _user!);

      if (newUser.updatedAt.isAfter(_user!.updatedAt)) {
        _user = newUser;
        localDataSource.cacheUser(_user!);
      }

      return Right(_user!);
    } catch (e) {
      Logger().e(e);
      return Left(UserGetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? gAcc = await googleSignIn.signIn();
      if (gAcc == null) {
        return Left(UserUnauthenticatedFailure("Couldn't sign in."));
      }
      final accToken = (await gAcc.authentication).accessToken;

      final response = await http.post(
        Uri.parse('$api/authentication/google-authentication'),
        body: {'token': accToken},
        headers: {'Accept': 'application/json'},
      ).onError((error, stackTrace) {
        googleSignIn.signOut();
        throw Exception(error);
      });

      final Map bodyMap = cast(jsonDecode(response.body));

      if (!response.ok) {
        Logger().e(response.body);
        Logger().e(response.statusCode);
        return Left(
          UserUnauthenticatedFailure(
            "Couldn't register: ${bodyMap['message']}",
          ),
        );
      }

      _user = UserModel.fromMap(bodyMap);
      localDataSource.cacheUser(_user!);

      return Right(_user!);
    } catch (e) {
      Logger().e(e);
      return Left(UserUnauthenticatedFailure("Couldn't sign in."));
    }
  }

  @override
  Future<Either<Failure, User>> login({required Map formMap}) async {
    try {
      final response = await http.post(
        Uri.parse('$api/authentication/login'),
        body: formMap,
        headers: {'Accept': 'application/json'},
      );

      final Map bodyMap = cast(jsonDecode(response.body));

      if (!response.ok) {
        Logger().e(response.body);
        Logger().e(response.statusCode);
        return Left(
          UserUnauthenticatedFailure(
            "Couldn't log in: ${bodyMap['message']}",
          ),
        );
      }

      _user = UserModel.fromMap(bodyMap);
      localDataSource.cacheUser(_user!);

      return Right(_user!);
    } catch (e) {
      Logger().e(e);
      return Left(UserUnauthenticatedFailure("Couldn't log in"));
    }
  }

  @override
  Future<Either<Failure, User>> register({required Map formMap}) async {
    try {
      final response = await http.post(
        Uri.parse('$api/authentication/register'),
        body: formMap,
        headers: {'Accept': 'application/json'},
      );

      final Map bodyMap = cast(jsonDecode(response.body));

      if (!response.ok) {
        Logger().e(response.body);
        Logger().e(response.statusCode);
        return Left(
          UserUnauthenticatedFailure(
            "Couldn't register: ${bodyMap['message']}",
          ),
        );
      }

      _user = UserModel.fromMap(bodyMap);
      localDataSource.cacheUser(_user!);

      return Right(_user!);
    } catch (e) {
      Logger().e(e);
      return Left(UserUnauthenticatedFailure("Couldn't register"));
    }
  }

  @override
  Future<Failure?> logout() async {
    if (!loggedIn) {
      return UserUnauthenticatedFailure('user not logged in');
    }

    try {
      final String? token = _user?.token;

      _user = null;

      await GoogleSignIn.standard().signOut();

      localDataSource.clearUser();

      final response = await http.get(
        Uri.parse('$api/user/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (!response.ok) {
        final Map bodyMap = cast(jsonDecode(response.body));
        Logger().e(response.body);
        Logger().e(response.statusCode);
        return UserUnauthenticatedFailure(
          "Couldn't logout: ${bodyMap['message']}",
        );
      }

      return null;
    } catch (e) {
      Logger().e(e);
      return UserUnauthenticatedFailure("Couldn't register");
    }
  }

  @override
  Future<bool> removeAccount({
    required String email,
    required String password,
  }) async {
    try {
      if (_user == null) {
        return false;
      }

      final response = await http.delete(
        Uri.parse('$api/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_user!.token}',
        },
        body: {'email': email, 'password': password},
      );

      if (!response.ok) {
        Logger().e(response.body);
        return false;
      }

      localDataSource.clearUser();
      _user = null;

      return true;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }
}
