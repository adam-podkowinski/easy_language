import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<Either<Failure, Settings>> changeSettings({
    bool? isStartup,
    ThemeMode? themeMode,
  });

  Future<Either<Failure, Settings>> getSettings();
}
