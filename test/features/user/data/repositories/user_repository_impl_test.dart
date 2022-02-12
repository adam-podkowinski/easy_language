// import 'package:dartz/dartz.dart';
// import 'package:easy_language/core/error/exceptions.dart';
// import 'package:easy_language/core/error/failures.dart';
// import 'package:easy_language/features/user/data/data_sources/settings_local_data_source.dart';
// import 'package:easy_language/features/user/data/data_sources/settings_remote_data_source.dart';
// import 'package:easy_language/features/user/data/models/settings_model.dart';
// import 'package:easy_language/features/user/data/repositories/settings_repository_impl.dart';
// import 'package:easy_language/features/user/domain/entities/user.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:language_picker/languages.dart';
// import 'package:mocktail/mocktail.dart';
//
// class MockSettingsLocalDataSource extends Mock
//     implements SettingsLocalDataSource {}
//
// class MockSettingsRemoteDataSource extends Mock
//     implements SettingsRemoteDataSource {}

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/user/data/data_sources/user_local_data_source.dart';
import 'package:easy_language/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:easy_language/features/user/data/repositories/user_repository_impl.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  late final UserRepositoryImpl userRepositoryImpl;

  setUpAll(() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    userRepositoryImpl = UserRepositoryImpl(
      localDataSource:
          UserLocalDataSourceImpl(userBox: await Hive.openBox(cachedUserId)),
      remoteDataSource: UserRemoteDataSourceImpl(),
    );
  });

  group('integration user tests', () {
    group('login', () {
      test(
        'should login successfully when data is correct',
        () async {
          final user = await userRepositoryImpl.login(
            formMap: {'email': 'adampodkdev@gmail.com', 'password': '123456'},
          );

          expect(user, const TypeMatcher<Right>());

          Logger().i(user);
        },
      );

      test(
        'should return an error when data is not correct',
        () async {
          final error = await userRepositoryImpl.login(
            formMap: {
              'email': 'elo',
              'password': '123456',
            },
          );

          expect(error, const TypeMatcher<Left>());

          Logger().i(error);
        },
      );
    });

    group('register', () {
      test(
        'should return a newly registered user when data is correct',
        () async {
          final user = await userRepositoryImpl.register(
            formMap: {
              'email': faker.internet.email(),
              'password': '123456',
              'password_confirmation': '123456',
              'name': 'adam'
            },
          );

          expect(user, const TypeMatcher<Right>());

          Logger().i(user);
        },
      );

      test(
        'should return an error when data is not correct',
        () async {
          final error = await userRepositoryImpl.register(
            formMap: {
              'email': faker.internet.email(),
              'password': '123456',
            },
          );

          expect(error, const TypeMatcher<Left>());

          Logger().i(error);
        },
      );
    });
  });
}

// late SettingsRepositoryImpl repository;
// late MockSettingsLocalDataSource mockLocalDataSource;
// late MockSettingsRemoteDataSource mockRemoteDataSource;
//
// setUp(() {
//   mockLocalDataSource = MockSettingsLocalDataSource();
//   mockRemoteDataSource = MockSettingsRemoteDataSource();
//   repository = SettingsRepositoryImpl(
//     localDataSource: mockLocalDataSource,
//     remoteDataSource: mockRemoteDataSource,
//   );
//   registerFallbackValue(SettingsModel(nativeLanguage: Languages.english));
// });
//
// group('getSettings', () {
//   final tSettings = SettingsModel(
//     isStartup: false,
//     themeMode: ThemeMode.dark,
//     nativeLanguage: Languages.english,
//   );
//   final tBlankSettings = SettingsModel(nativeLanguage: Languages.english);
//
//   test(
//     '''
//     should return last locally cached user
//     when the cache data is present''',
//     () async {
//       when(() => mockLocalDataSource.getLocalSettings())
//           .thenAnswer((_) async => tSettings);
//
//       final result = await repository.getSettings();
//       verify(() => mockLocalDataSource.getLocalSettings());
//       verifyNoMoreInteractions(mockLocalDataSource);
//       expect(result, equals(Right(tSettings)));
//     },
//   );
//
//   test(
//     '''
//     should return CacheFailure with blank user
//     when there is no cache data is present''',
//     () async {
//       when(() => mockLocalDataSource.getLocalSettings())
//           .thenThrow(CacheException());
//
//       final result = await repository.getSettings();
//       expect(result, equals(Left(SettingsGetFailure(tBlankSettings))));
//     },
//   );
// });
//
// group('changeSettings', () {
//   final tBlankSettings = SettingsModel(nativeLanguage: Languages.english);
//   final tNewThemeMode = SettingsModel.mapThemeModeToString(ThemeMode.dark);
//   const tNewIsStartup = false;
//   final tNewSettingsMap = {
//     Settings.isStartupId: tNewIsStartup,
//     Settings.themeModeId: tNewThemeMode,
//   };
//   final tNewSettings = tBlankSettings.copyWithMap(tNewSettingsMap);
//
//   test(
//     'should change user parameters',
//     () async {
//       when(() => mockLocalDataSource.getLocalSettings())
//           .thenAnswer((_) async => tBlankSettings);
//       when(() => mockLocalDataSource.cacheSettings(any()))
//           .thenAnswer((_) async => tNewSettings);
//       await repository.changeSettings(settingsMap: tNewSettingsMap);
//       final result = await repository.getSettings();
//       expect(result, equals(Right(tNewSettings)));
//     },
//   );
// });
