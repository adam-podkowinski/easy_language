import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:easy_language/features/settings/data/data_sources/settings_remote_data_source.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:easy_language/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsLocalDataSource extends Mock
    implements SettingsLocalDataSource {}

class MockSettingsRemoteDataSource extends Mock
    implements SettingsRemoteDataSource {}

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsLocalDataSource mockLocalDataSource;
  late MockSettingsRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockSettingsLocalDataSource();
    mockRemoteDataSource = MockSettingsRemoteDataSource();
    repository = SettingsRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
    registerFallbackValue(SettingsModel(nativeLanguage: Languages.english));
  });

  group('getSettings', () {
    final tSettings = SettingsModel(
      isStartup: false,
      themeMode: ThemeMode.dark,
      nativeLanguage: Languages.english,
    );
    final tBlankSettings = SettingsModel(nativeLanguage: Languages.english);

    test(
      '''
      should return last locally cached settings
      when the cache data is present''',
      () async {
        when(() => mockLocalDataSource.getLocalSettings())
            .thenAnswer((_) async => tSettings);

        final result = await repository.getSettings();
        verify(() => mockLocalDataSource.getLocalSettings());
        verifyNoMoreInteractions(mockLocalDataSource);
        expect(result, equals(Right(tSettings)));
      },
    );

    test(
      '''
      should return CacheFailure with blank settings
      when there is no cache data is present''',
      () async {
        when(() => mockLocalDataSource.getLocalSettings())
            .thenThrow(CacheException());

        final result = await repository.getSettings();
        expect(result, equals(Left(SettingsGetFailure(tBlankSettings))));
      },
    );
  });

  group('changeSettings', () {
    final tBlankSettings = SettingsModel(nativeLanguage: Languages.english);
    final tNewThemeMode = SettingsModel.mapThemeModeToString(ThemeMode.dark);
    const tNewIsStartup = false;
    final tNewSettingsMap = {
      Settings.isStartupId: tNewIsStartup,
      Settings.themeModeId: tNewThemeMode,
    };
    final tNewSettings = tBlankSettings.copyWithMap(tNewSettingsMap);

    test(
      'should change settings parameters',
      () async {
        when(() => mockLocalDataSource.getLocalSettings())
            .thenAnswer((_) async => tBlankSettings);
        when(() => mockLocalDataSource.cacheSettings(any()))
            .thenAnswer((_) async => tNewSettings);
        await repository.changeSettings(settingsMap: tNewSettingsMap);
        final result = await repository.getSettings();
        expect(result, equals(Right(tNewSettings)));
      },
    );
  });
}
