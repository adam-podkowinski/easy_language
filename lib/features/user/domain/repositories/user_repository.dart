import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> changeSettings({required Map settingsMap});

  Future<Either<Failure, User>> getSettings();

  Future<Either<Failure, User>> fetchSettingsRemotely();

  Future saveSettings();
}
