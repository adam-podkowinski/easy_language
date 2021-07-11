import 'dart:convert';
import 'dart:io';

import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockBox extends Mock implements Box {}

void main() {
  late SettingsLocalDataSourceImpl dataSource;
  late MockBox mockBox;

  setUpAll(() {
    Hive.init(Directory.systemTemp.path);
  });

  setUp(() {
    mockBox = MockBox();
    dataSource = SettingsLocalDataSourceImpl(settingsBox: mockBox);
  });

  group('getLocalSettings', () {
    final tSettingsModel = SettingsModel.fromMap(
      jsonDecode(fixture('settings.json')) as Map,
    );

    test(
      '''
    should return [SettingsModel] from [Box]
    when there is one in the cache''',
      () async {
        when(() => mockBox.toMap()).thenReturn(
          jsonDecode(fixture('settings.json')) as Map,
        );
        when(() => mockBox.isEmpty).thenReturn(false);
        when(() => mockBox.isNotEmpty).thenReturn(true);

        final result = await dataSource.getLocalSettings();

        verify(() => mockBox.toMap());
        expect(result, equals(tSettingsModel));
      },
    );

    test(
      'should throw a [CacheException] when there is not a cached value',
      () async {
        when(() => mockBox.toMap()).thenReturn({});
        when(() => mockBox.isEmpty).thenReturn(true);
        when(() => mockBox.isNotEmpty).thenReturn(false);

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
        when(() => mockBox.putAll(any())).thenAnswer((_) => Future.value());

        await dataSource.cacheSettings(tSettingsModel);

        final expectedMap = tSettingsModel.toMap();
        verify(
          () => mockBox.putAll(expectedMap),
        );
      },
    );
  });
}
