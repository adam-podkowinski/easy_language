import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_language/core/api/api_repository.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/dictionaries/data/data_sources/dictionary_local_data_source.dart';
import 'package:easy_language/features/dictionaries/data/data_sources/dictionary_remote_data_source.dart';
import 'package:easy_language/features/dictionaries/data/repositories/dictionaries_repository_impl.dart';
import 'package:easy_language/features/dictionaries/domain/repositories/dictionaries_repository.dart';
import 'package:easy_language/features/dictionaries/presentation/manager/dictionaries_provider.dart';
import 'package:easy_language/features/user/data/data_sources/user_local_data_source.dart';
import 'package:easy_language/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:easy_language/features/user/data/repositories/user_repository_impl.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final sl = GetIt.instance;

Future registerUser() async {
  // Provider
  sl.registerFactory(
    () => UserProvider(
      userRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      dio: sl(),
    ),
  );

  // Data sources
  final userBox = await Hive.openBox(cachedUserBoxId);
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => UserLocalDataSourceImpl(userBox: userBox),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(),
  );
}

Future registerDictionaries() async {
  // Provider
  sl.registerFactory(
    () => DictionariesProvider(
      dictionariesRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<DictionariesRepository>(
    () => DictionariesRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      dio: sl(),
    ),
  );

  // Data sources
  final dictionariesBox = await Hive.openBox(cachedDictionariesBoxId);
  sl.registerLazySingleton<DictionariesLocalDataSource>(
    () => DictionariesLocalDataSourceImpl(dictionariesBox: dictionariesBox),
  );
  sl.registerLazySingleton<DictionariesRemoteDataSource>(
    () => DictionariesRemoteDataSourceImpl(),
  );
}

Future registerOthersFirst() async {
  final box = await Hive.openBox(cachedApiBoxId);
  sl.registerSingleton<ApiRepository>(
    ApiRepositoryImpl(
      Dio(),
      box,
    ),
  );
}

Future clearAll() async {
  await (await Hive.openBox(cachedUserBoxId)).clear();
  await (await Hive.openBox(cachedDictionariesBoxId)).clear();
  await (await Hive.openBox(cachedApiBoxId)).clear();
  await (await Hive.openBox(cachedConfigBoxId)).clear();
}

Future init() async {
  // Initial
  if (!kIsWeb) {
    final Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  // DEBUG
  //if (kDebugMode) {
  //  await clearAll();
  //}

  // Features
  await registerOthersFirst();
  await registerUser();
  await registerDictionaries();
}
