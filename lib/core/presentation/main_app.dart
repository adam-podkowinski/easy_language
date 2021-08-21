import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/flashcard/presentation/manager/flashcard_provider.dart';
import 'package:easy_language/features/flashcard/presentation/pages/flashcard_page.dart';
import 'package:easy_language/features/login/presentation/pages/introduction_page.dart';
import 'package:easy_language/features/settings/presentation/pages/settings_page.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:easy_language/features/word_bank/presentation/pages/word_bank_page.dart';
import 'package:easy_language/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  final ThemeMode? themeMode;
  final bool showIntroduction;
  final Failure? failure;

  const MainApp(
    this.themeMode, {
    Key? key,
    this.failure,
    required this.showIntroduction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WordBankProvider>(
      create: (context) {
        final provider = sl<WordBankProvider>();
        provider.initWordBank();
        return provider;
      },
      child: MaterialApp(
        title: 'Easy Language',
        themeMode: themeMode,
        theme: CustomTheme.buildLight(context),
        darkTheme: CustomTheme.buildDark(context),
        debugShowCheckedModeBanner: false,
        initialRoute: showIntroduction ? introductionPageId : wordBankPageId,
        routes: {
          wordBankPageId: (context) => const WordBankPage(),
          introductionPageId: (context) => const IntroductionPage(),
          settingsPageId: (context) => const SettingsPage(),
          flashcardsPageId: (context) => ChangeNotifierProvider(
                create: (context) {
                  final provider = sl<FlashcardProvider>();
                  provider.getNextFlashcard(
                    context.read<WordBankProvider>().wordBank,
                    language: context.read<WordBankProvider>().currentLanguage,
                    init: true,
                  );
                  return provider;
                },
                child: const FlashcardPage(),
              ),
        },
      ),
    );
  }
}
