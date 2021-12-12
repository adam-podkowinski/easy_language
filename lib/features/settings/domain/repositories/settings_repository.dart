import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, User>> changeSettings({
    required Map<dynamic, dynamic> settingsMap,
  });

  Future<Either<Failure, User>> getSettings();

  Future<Either<Failure, User>> fetchSettingsRemotely();

  Future saveSettings();
}
