import 'dart:io';

import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/user/data/data_sources/user_local_data_source.dart';
import 'package:easy_language/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:easy_language/features/user/data/repositories/user_repository_impl.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:easy_language/features/word_bank/data/data_sources/dictionary_local_data_source.dart';
import 'package:easy_language/features/word_bank/data/data_sources/dictionary_remote_data_source.dart';
import 'package:easy_language/features/word_bank/data/repositories/dictionary_repository_impl.dart';
import 'package:easy_language/features/word_bank/domain/repositories/dictionary_repository.dart';
import 'package:easy_language/features/word_bank/presentation/manager/dictionary_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future registerUser() async {
  // Provider
  sl.registerLazySingleton(
    () => UserProvider(
      userRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  final userBox = await Hive.openBox(cachedUserId);
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => UserLocalDataSourceImpl(userBox: userBox),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(),
  );
}

Future registerWordBank() async {
  // Provider
  sl.registerFactory(
    () => DictionaryProvider(
      dictionaryRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<DictionaryRepository>(
    () => DictionaryRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  final wordBankBox = await Hive.openBox(cachedWordBankId);
  sl.registerLazySingleton<DictionaryLocalDataSource>(
    () => DictionaryLocalDataSourceImpl(dictionariesBox: wordBankBox),
  );
  sl.registerLazySingleton<DictionaryRemoteDataSource>(
    () => DictionaryRemoteDataSourceImpl(),
  );
}

Future clearAll() async {
  await (await SharedPreferences.getInstance()).clear();
  await (await Hive.openBox(cachedUserId)).clear();
  await (await Hive.openBox(cachedWordBankId)).clear();
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
  await registerUser();
  await registerWordBank();
}
