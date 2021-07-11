import 'dart:convert';

import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SettingsLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        SettingsLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLocalSettings', () {
    final tSettingsModel = SettingsModel.fromMap(jsonDecode(
      fixture('settings.json'),
    ).cast<String, dynamic>() as Map<String, dynamic>);

    test(
      '''
    should return [SettingsModel] from [SharedPreferences]
    when there is one in the cache''',
      () async {
        when(() => mockSharedPreferences.getString(any()))
            .thenReturn(fixture('settings.json'));

        final result = await dataSource.getLocalSettings();

        verify(() => mockSharedPreferences.getString(cachedSettingsId));
        expect(result, equals(tSettingsModel));
      },
    );

    test(
      'should throw a [CacheException] when there is not a cached value',
      () async {
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);

        final call = dataSource.getLocalSettings;

        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheSettings', () {
    const tSettingsModel = SettingsModel(
      isStartup: false,
      themeMode: ThemeMode.dark,
    );

    test(
      'should call SharedPreferences to cache the data',
      () async {
        when(() => mockSharedPreferences.setString(any(), any()))
            .thenAnswer((_) => Future.value(true));

        await dataSource.cacheSettings(tSettingsModel);

        final expectedJsonString = jsonEncode(tSettingsModel.toMap());
        verify(
          () => mockSharedPreferences.setString(
            cachedSettingsId,
            expectedJsonString,
          ),
        );
      },
    );
  });
}
