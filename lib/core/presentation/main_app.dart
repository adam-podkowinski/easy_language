import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/dictionaries/presentation/manager/dictionary_provider.dart';
import 'package:easy_language/features/dictionaries/presentation/pages/dictionaries_page.dart';
import 'package:easy_language/features/dictionaries/presentation/pages/flashcard_page.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:easy_language/features/user/presentation/pages/settings_page.dart';
import 'package:easy_language/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        ChangeNotifierProvider<DictionariesProvider>(
          create: (context) {
            final provider = sl<DictionariesProvider>();
            provider.initDictionaryProvider(context.read<UserProvider>().user!);
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
        initialRoute: dictionariesPageId,
        builder: (context, widget) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget ?? const SizedBox(),
          );
        },
        routes: {
          dictionariesPageId: (context) => const DictionariesPage(),
          settingsPageId: (context) => const SettingsPage(),
          flashcardsPageId: (context) => const FlashcardPage(),
        },
      ),
    );
  }
}
