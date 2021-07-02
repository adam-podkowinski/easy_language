import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/view/styles.dart';
import 'package:easy_language/features/login/presentation/pages/introduction_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(EasyLanguage());
}

class EasyLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: SCREEN_SIZE,
      builder: () => MaterialApp(
        title: 'Easy Language',
        themeMode: ThemeMode.dark,
        theme: buildLight(context),
        darkTheme: buildDark(context),
        debugShowCheckedModeBanner: false,
        home: SafeArea(child: IntroductionPage()),
      ),
    );
  }
}
