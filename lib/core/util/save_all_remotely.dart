import 'package:easy_language/features/flashcard/presentation/manager/flashcard_provider.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_provider.dart';
import 'package:easy_language/features/word_bank/presentation/manager/dictionary_provider.dart';

Future saveAllRemotely(
  DictionaryProvider dictionaryProvider,
  FlashcardProvider flashcardProvider,
  SettingsProvider settingsProvider,
) async {
  await dictionaryProvider.saveCurrentDictionary();
  await dictionaryProvider.saveWordBank();
  await flashcardProvider.saveFlashcard();
  await settingsProvider.saveSettings();
}
