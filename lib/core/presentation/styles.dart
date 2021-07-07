import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextTheme buildTextTheme(BuildContext context, Color color) {
  return TextTheme(
    headline5: TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.w900,
      color: color,
      fontFamily: 'Mulish',
    ),
    headline6: const TextStyle(fontWeight: FontWeight.bold),
    headline4: const TextStyle(),
    headline3: const TextStyle(),
    headline2: const TextStyle(),
    headline1: const TextStyle(),
    caption: const TextStyle(),
    button: const TextStyle(),
    bodyText1: const TextStyle(),
    bodyText2: const TextStyle(),
    overline: const TextStyle(),
    subtitle1: const TextStyle(),
    subtitle2: const TextStyle(),
  );
}

ThemeData buildLight(BuildContext context) {
  const brightness = Brightness.light;
  const primary = Color(0xFF1889f8);
  const primaryVariant = Color(0xff1863f8);
  const secondary = Color(0xFFf88718);
  const secondaryVariant = Color(0xfff85f18);
  const surface = primary;
  const background = Colors.white;
  const error = Colors.deepOrange;
  const onPrimary = Colors.white;
  const onSecondary = Colors.white;
  const onSurface = Colors.white;
  const onBackground = Colors.black;
  const onError = Colors.white;

  final textTheme = buildTextTheme(context, primary);

  return ThemeData.from(
    colorScheme: const ColorScheme(
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
  const error = Colors.deepOrange;
  const onPrimary = Colors.white;
  const onSecondary = Colors.white;
  const onSurface = Colors.white;
  const onBackground = Colors.white;
  const onError = Colors.white;

  final textTheme = buildTextTheme(context, primary);

  return ThemeData.from(
    colorScheme: const ColorScheme(
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
  return const AppBarTheme(
    backwardsCompatibility: false,
    elevation: 0.0,
    centerTitle: true,
  );
}
