import 'dart:io';

import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:easy_language/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';
import 'package:easy_language/features/settings/domain/use_cases/change_settings.dart';
import 'package:easy_language/features/settings/domain/use_cases/get_settings.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_bloc.dart';
import 'package:easy_language/features/word_bank/data/data_sources/word_bank_local_data_source.dart';
import 'package:easy_language/features/word_bank/data/repositories/word_bank_repository_impl.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/add_language_to_word_bank.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/change_current_language.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/edit_word_list.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_current_language.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_word_bank.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final sl = GetIt.instance;

Future registerSettings() async {
  // bloc
  sl.registerFactory(
    () => SettingsBloc(
      getSettings: sl(),
      changeSettings: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => SingletonSettingsBloc(
      getSettings: sl(),
      changeSettings: sl(),
    ),
  );

  // use cases
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => ChangeSettings(sl()));

  // repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  // data sources
  final settingsBox = await Hive.openBox(cachedSettingsId);
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(settingsBox: settingsBox),
  );
}

Future registerWordBank() async {
  // bloc
  sl.registerFactory(
    () => WordBankBloc(
      getWordBank: sl(),
      getCurrentLanguage: sl(),
      editWordList: sl(),
    ),
  );

  // use cases
  sl.registerLazySingleton(() => GetWordBank(sl()));
  sl.registerLazySingleton(() => AddLanguageToWordBank(sl()));
  sl.registerLazySingleton(() => ChangeCurrentLanguage(sl()));
  sl.registerLazySingleton(() => EditWordList(sl()));
  sl.registerLazySingleton(() => GetCurrentLanguage(sl()));

  // repositories
  sl.registerLazySingleton<WordBankRepository>(
    () => WordBankRepositoryImpl(
      sl(),
    ),
  );

  // data sources
  final wordBankBox = await Hive.openBox(cachedWordBankId);
  sl.registerLazySingleton<WordBankLocalDataSource>(
    () => WordBankLocalDataSourceImpl(wordBankBox: wordBankBox),
  );
}

Future init() async {
  final Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  // Features
  await registerSettings();
  await registerWordBank();
}
