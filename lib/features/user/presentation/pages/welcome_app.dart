import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/user/presentation/pages/authenticate_page.dart';
import 'package:easy_language/features/user/presentation/pages/introduction_page.dart';
import 'package:flutter/material.dart';

class WelcomeApp extends StatelessWidget {
  final bool showIntroduction;

  const WelcomeApp({Key? key, required this.showIntroduction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Language',
      debugShowCheckedModeBanner: false,
      theme: buildLight(context),
      darkTheme: buildDark(context),
      themeMode: ThemeMode.dark,
      home: showIntroduction
          ? const IntroductionPage()
          : const AuthenticatePage(),
    );
  }
}
