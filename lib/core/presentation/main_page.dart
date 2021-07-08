import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/login/presentation/pages/introduction_page.dart';
import 'package:easy_language/features/word_bank/presentation/pages/word_bank_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    if (failure is SettingsCacheFailure) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Error while changing settings ${failure.toString()}',
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
      );
    }
    return MaterialApp(
      title: 'Easy Language',
      themeMode: themeMode,
      theme: CustomTheme.buildLight(context),
      darkTheme: CustomTheme.buildDark(context),
      debugShowCheckedModeBanner: false,
      initialRoute: showIntroduction ? introductionPageId : wordBankPageId,
      routes: {
        wordBankPageId: (context) => const WordBankPage(),
        introductionPageId: (context) => const IntroductionPage(),
      },
    );
  }
}
