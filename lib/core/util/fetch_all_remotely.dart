import 'package:easy_language/features/flashcard/presentation/manager/flashcard_provider.dart';
import 'package:easy_language/features/settings/presentation/manager/user_provider.dart';
import 'package:easy_language/features/word_bank/presentation/manager/dictionary_provider.dart';

Future fetchAllRemotely(
  DictionaryProvider dictionaryProvider,
  FlashcardProvider flashcardProvider,
  UserProvider settingsProvider,
) async {
  await dictionaryProvider.fetchDictionaries();
  await flashcardProvider.fetchFlashcard();
  await settingsProvider.fetchSettings();
}
