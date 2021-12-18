import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/data/data_sources/user_local_data_source.dart';
import 'package:easy_language/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  bool _initial = true;

  UserModel? _user;

  bool get loggedIn => _user != null;

  final SettingsLocalDataSource localDataSource;
  final SettingsRemoteDataSource remoteDataSource;

  UserRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<void> _ensureInitialized() async {
    if (_initial) {
      await getUser();
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

      _user = _user!.copyWithMap(userMap);

      localDataSource.cacheUser(_user!);
      remoteDataSource.saveUser(_user!);
      return Right(_user!);
    } catch (_) {
      return Left(UserCacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      if (_initial) {
        _user = await localDataSource.getCachedUser();
        _initial = false;
      }
      return loggedIn
          ? Right(_user!)
          : Left(UserUnauthenticatedFailure("couldn't get a user"));
    } catch (_) {
      _initial = false;
      return Left(UserUnauthenticatedFailure("couldn't get a user"));
    }
  }

  @override
  Future<Either<Failure, User>> fetchUser() async {
    if (!loggedIn) {
      return Left(UserUnauthenticatedFailure("user not logged in"));
    }

    try {
      _user = await remoteDataSource.fetchUser();
      localDataSource.cacheUser(_user!);
      _initial = false;
      return Right(_user!);
    } catch (_) {
      _initial = false;
      return Left(UserUnauthenticatedFailure("couldn't fetch user"));
    }
  }

  @override
  Future<Either<Failure, User>> cacheUser() async {
    if (!loggedIn) {
      return Left(UserUnauthenticatedFailure("user not logged in"));
    }

    try {
      localDataSource.cacheUser(_user!);
      await remoteDataSource.saveUser(_user!);
      return Right(_user!);
    } catch (_) {
      return Right(_user!);
    }
  }

  @override
  Future<Either<Failure, User>> login({required Map loginMap}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> register({required Map registerMap}) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
