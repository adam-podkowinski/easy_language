import 'package:easy_language/features/flashcard/presentation/manager/flashcard_provider.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_provider.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';

Future saveAllRemotely(
  WordBankProvider wordBankProvider,
  FlashcardProvider flashcardProvider,
  SettingsProvider settingsProvider,
) async {
  await wordBankProvider.saveCurrentLanguage();
  await wordBankProvider.saveWordBank();
  await flashcardProvider.saveFlashcard();
  await settingsProvider.saveSettings();
}