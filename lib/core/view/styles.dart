import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData buildLight(BuildContext context) {
  const brightness = Brightness.light;
  const primary = Color(0xFF1889f8);
  const primaryVariant = Color(0xff1863f8);
  const secondary = Color(0xFFf88718);
  const secondaryVariant = Color(0xfff85f18);
  const surface = primary;
  const background = Colors.white;
  const error = Colors.red;
  const onPrimary = Colors.white;
  const onSecondary = Colors.white;
  const onSurface = Colors.white;
  const onBackground = Colors.black;
  const onError = Colors.white;

  final textTheme = TextTheme(
    headline5: TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.bold,
      color: primaryVariant,
    ),
  );

  return ThemeData.from(
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: primary,
      primaryVariant: primaryVariant,
      secondary: secondary,
      secondaryVariant: secondaryVariant,
      surface: surface,
      background: background,
      error: error,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onSurface: onSurface,
      onBackground: onBackground,
      onError: onError,
    ),
    textTheme: textTheme,
  ).copyWith(
    appBarTheme: appBarTheme(context),
  );
}

ThemeData buildDark(BuildContext context) {
  const brightness = Brightness.dark;
  const primary = Color(0xFF1889f8);
  const primaryVariant = Color(0xff1863f8);
  const secondary = Color(0xFFf88718);
  const secondaryVariant = Color(0xfff85f18);
  const surface = primary;
  const background = Color(0xFF191919);
  const error = Colors.red;
  const onPrimary = Colors.white;
  const onSecondary = Colors.white;
  const onSurface = Colors.white;
  const onBackground = Colors.white;
  const onError = Colors.white;

  final textTheme = TextTheme(
    headline5: TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.bold,
    ),
  );

  return ThemeData.from(
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: primary,
      primaryVariant: primaryVariant,
      secondary: secondary,
      secondaryVariant: secondaryVariant,
      surface: surface,
      background: background,
      error: error,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onSurface: onSurface,
      onBackground: onBackground,
      onError: onError,
    ),
    textTheme: textTheme,
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
