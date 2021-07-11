import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  bool _initial = true;
  SettingsModel _settings = const SettingsModel();
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  Future<void> _ensureInitialized() async {
    if (_initial) {
      await getSettings();
    }
  }

  @override
  Future<Either<Failure, Settings>> changeSettings({
    required Map<String, dynamic> settingsMap,
  }) async {
    try {
      await _ensureInitialized();

      _settings = _settings.copyWithMap(settingsMap);

      localDataSource.cacheSettings(_settings);
      return Right(_settings);
    } on CacheException {
      return Left(SettingsCacheFailure(_settings));
    }
  }

  @override
  Future<Either<Failure, Settings>> getSettings() async {
    try {
      if (_initial) {
        _settings = await localDataSource.getLocalSettings();
        _initial = false;
      }
      return Right(_settings);
    } on CacheException {
      _initial = false;
      return Left(SettingsGetFailure(_settings));
    }
  }
}
