import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/src/material/app.dart';

// TODO: implement  SettingsRepository
class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<Either<Failure, Settings>> changeSettings({
    bool? isStartup,
    ThemeMode? themeMode,
  }) {
    // TODO: implement changeSettings
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Settings>> getSettings() {
    // TODO: implement getSettings
    throw UnimplementedError();
  }
}
