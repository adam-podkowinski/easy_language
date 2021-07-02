import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData buildLight(BuildContext context) {
  return ThemeData.from(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFf88718),
      primaryVariant: Color(0xfff85f18),
      secondary: Color(0xFF1889f8),
      secondaryVariant: Color(0xff1863f8),
      surface: Color(0xFFf88718),
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.black,
      onError: Colors.white,
    ),
  ).copyWith(
    appBarTheme: appBarTheme(context),
  );
}

AppBarTheme appBarTheme(BuildContext context) {
  return AppBarTheme(
    backwardsCompatibility: false,
    titleTextStyle: TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 23.sp,
      fontWeight: FontWeight.bold,
    ),
  );
}

ThemeData buildDark(BuildContext context) {
  return ThemeData.from(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFf88718),
      primaryVariant: Color(0xfff85f18),
      secondary: Color(0xFF1889f8),
      secondaryVariant: Color(0xff1863f8),
      surface: Color(0xFFf88718),
      background: Color(0xFF191919),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
  ).copyWith(
    appBarTheme: appBarTheme(context),
  );
}
