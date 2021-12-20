import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/flashcard/presentation/manager/flashcard_provider.dart';
import 'package:easy_language/features/flashcard/presentation/pages/flashcard_page.dart';
import 'package:easy_language/features/user/presentation/pages/settings_page.dart';
import 'package:easy_language/features/word_bank/presentation/manager/dictionary_provider.dart';
import 'package:easy_language/features/word_bank/presentation/pages/word_bank_page.dart';
import 'package:easy_language/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  final ThemeMode? themeMode;
  final Failure? failure;

  const MainApp(
    this.themeMode, {
    Key? key,
    this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DictionaryProvider>(
          create: (context) {
            final provider = sl<DictionaryProvider>();
            provider.initDictionaryProvider();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          lazy: true,
          create: (context) {
            final provider = sl<FlashcardProvider>();
            provider.getNextFlashcard(
              context.read<DictionaryProvider>().currentDictionary,
              init: true,
            );
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Easy Language',
        themeMode: themeMode,
        theme: buildLight(context),
        darkTheme: buildDark(context),
        debugShowCheckedModeBanner: false,
        initialRoute: wordBankPageId,
        routes: {
          wordBankPageId: (context) => const WordBankPage(),
          settingsPageId: (context) => const SettingsPage(),
          flashcardsPageId: (context) => const FlashcardPage(),
        },
      ),
    );
  }
}
