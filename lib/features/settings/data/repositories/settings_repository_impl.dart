import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsModel _settings = SettingsModel(initial: true);
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Settings>> changeSettings({
    bool? isStartup,
    ThemeMode? themeMode,
  }) async {
    try {
      if (_settings.initial) {
        await getSettings();
      }
      if (isStartup != null) {
        _settings.isStartup = isStartup;
      }
      if (themeMode != null) {
        _settings.themeMode = themeMode;
      }
      localDataSource.cacheSettings(_settings);
      return Right(_settings);
    } on CacheException {
      return Left(CacheFailure(_settings));
    }
  }

  @override
  Future<Either<Failure, Settings>> getSettings() async {
    try {
      if (_settings.initial) {
        _settings = await localDataSource.getLocalSettings();
        _settings.initial = false;
      }
      return Right(_settings);
    } on CacheException {
      _settings.initial = false;
      return Left(CacheFailure(_settings));
    }
  }
}
