import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> editUser({required Map userMap});

  Future<Either<Failure, User>> getUser();

  Future<Either<Failure, User>> fetchUser();

  Future<Either<Failure, User>> login({required Map formMap});

  Future<Either<Failure, User>> register({required Map formMap});

  Future<Failure?> logout();

  Future cacheUser();
}
