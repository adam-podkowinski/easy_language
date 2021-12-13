import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/data/data_sources/settings_local_data_source.dart';
import 'package:easy_language/features/user/data/data_sources/settings_remote_data_source.dart';
import 'package:easy_language/features/user/data/models/settings_model.dart';
import 'package:easy_language/features/user/domain/entities/settings.dart';
import 'package:easy_language/features/user/domain/repositories/settings_repository.dart';
import 'package:language_picker/languages.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  bool _initial = true;
  SettingsModel _settings = SettingsModel(
    nativeLanguage: Languages.english,
  );

  final SettingsLocalDataSource localDataSource;
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<void> _ensureInitialized() async {
    if (_initial) {
      await getSettings();
    }
  }

  @override
  Future<Either<Failure, User>> changeSettings({
    required Map settingsMap,
  }) async {
    try {
      await _ensureInitialized();

      _settings = _settings.copyWithMap(settingsMap);

      localDataSource.cacheSettings(_settings);
      remoteDataSource.saveSettings(_settings);
      return Right(_settings);
    } catch (_) {
      return Left(SettingsCacheFailure(_settings));
    }
  }

  @override
  Future<Either<Failure, User>> getSettings() async {
    try {
      if (_initial) {
        _settings = await localDataSource.getLocalSettings();
        _initial = false;
      }
      return Right(_settings);
    } catch (_) {
      _initial = false;
      return Left(SettingsGetFailure(_settings));
    }
  }

  @override
  Future<Either<Failure, User>> fetchSettingsRemotely() async {
    try {
      _settings = await remoteDataSource.fetchSettings();
      localDataSource.cacheSettings(_settings);
      _initial = false;
      return Right(_settings);
    } catch (_) {
      _initial = false;
      _settings = SettingsModel(
        nativeLanguage: Languages.english,
      );
      localDataSource.cacheSettings(_settings);
      return Left(SettingsGetFailure(_settings));
    }
  }

  @override
  Future saveSettings() async {
    try {
      localDataSource.cacheSettings(_settings);
      await remoteDataSource.saveSettings(_settings);
    } catch (_) {
      return;
    }
  }
}
