import 'package:easy_language/features/flashcard/presentation/manager/flashcard_provider.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_provider.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';

Future fetchAllRemotely(
  WordBankProvider wordBankProvider,
  FlashcardProvider flashcardProvider,
  SettingsProvider settingsProvider,
) async {
  await wordBankProvider.fetchDictionaries();
  await flashcardProvider.fetchFlashcard();
  await settingsProvider.fetchSettings();
}
