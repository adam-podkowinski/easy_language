import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, Settings>> changeSettings({
    required Map<String, dynamic> settingsMap,
  });

  Future<Either<Failure, Settings>> getSettings();
}
