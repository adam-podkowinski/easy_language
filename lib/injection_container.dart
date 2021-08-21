import 'dart:io';

import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/flashcard/data/data_sources/flashcard_local_data_source.dart';
import 'package:easy_language/features/flashcard/data/repositories/flashcard_repository_impl.dart';
import 'package:easy_language/features/flashcard/domain/repositories/flashcard_repository.dart';
import 'package:easy_language/features/flashcard/presentation/manager/flashcard_provider.dart';
import 'package:easy_language/features/login/presentation/manager/login_provider.dart';
import 'package:easy_language/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:easy_language/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_provider.dart';
import 'package:easy_language/features/word_bank/data/data_sources/word_bank_local_data_source.dart';
import 'package:easy_language/features/word_bank/data/repositories/word_bank_repository_impl.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final sl = GetIt.instance;

Future registerSettings() async {
  // Provider
  sl.registerLazySingleton(
    () => SettingsProvider(
      settingsRepository: sl<SettingsRepository>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  final settingsBox = await Hive.openBox(cachedSettingsId);
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(settingsBox: settingsBox),
  );
}

Future registerWordBank() async {
  // Provider
  sl.registerFactory(
    () => WordBankProvider(
      wordBankRepository: sl<WordBankRepository>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<WordBankRepository>(
    () => WordBankRepositoryImpl(
      sl(),
    ),
  );

  // Data sources
  final wordBankBox = await Hive.openBox(cachedWordBankId);
  sl.registerLazySingleton<WordBankLocalDataSource>(
    () => WordBankLocalDataSourceImpl(wordBankBox: wordBankBox),
  );
}

Future registerFlashcard() async {
  // Provider
  sl.registerFactory(
    () => FlashcardProvider(
      flashcardRepository: sl<FlashcardRepository>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<FlashcardRepository>(
    () => FlashcardRepositoryImpl(
      localDataSource: sl<FlashcardLocalDataSource>(),
    ),
  );

  // Data sources
  final flashcardBox = await Hive.openBox(cachedCurrentFlashcardId);
  sl.registerLazySingleton<FlashcardLocalDataSource>(
    () => FlashcardLocalDataSourceImpl(flashcardBox: flashcardBox),
  );
}

Future registerLogin() async {
  sl.registerFactory(() => LoginProvider());
}

Future init() async {
  // Initial
  final Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  // Features
  await registerSettings();
  await registerWordBank();
  await registerFlashcard();
  await registerLogin();
}
