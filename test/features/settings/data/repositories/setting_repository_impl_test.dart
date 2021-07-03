import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:easy_language/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsLocalDataSource extends Mock
    implements SettingsLocalDataSource {}

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockSettingsLocalDataSource();
    repository = SettingsRepositoryImpl(localDataSource: mockLocalDataSource);
    registerFallbackValue(SettingsModel());
  });

  group('getSettings', () {
    final tSettings = SettingsModel(
      isStartup: false,
      themeMode: ThemeMode.dark,
      initial: false,
    );
    final tBlankSettings = SettingsModel();

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
        expect(result, equals(Left(CacheFailure(tBlankSettings))));
      },
    );
  });

  group('changeSettings', () {
    final tBlankSettings = SettingsModel(
      initial: false,
    );
    const tNewThemeMode = ThemeMode.dark;
    const tNewIsStartup = false;
    final tNewSettings = SettingsModel(
      isStartup: tNewIsStartup,
      themeMode: tNewThemeMode,
      initial: false,
    );

    test(
      'should change settings parameters',
      () async {
        when(() => mockLocalDataSource.getLocalSettings())
            .thenAnswer((_) async => tBlankSettings);
        when(() => mockLocalDataSource.cacheSettings(any()))
            .thenAnswer((_) async => tNewSettings);
        await repository.changeSettings(
          themeMode: tNewThemeMode,
          isStartup: tNewIsStartup,
        );
        final result = await repository.getSettings();
        expect(result, equals(Right(tNewSettings)));
      },
    );
  });
}
