import 'package:flutter/material.dart';

const primary = Color(0xff148af9);

const primaryVariant = Color(0xff4f42ee);

const secondary = Color(0xFFf98314);
const secondaryVariant = Color(0xffd97212);
const surface = primary;
const error = Colors.redAccent;
const onPrimary = Colors.white;
const onSecondary = Colors.white;
const onSurface = Colors.white;
const onError = Colors.white;

//Depending on theming
const brightnessLight = Brightness.light;
const brightnessDark = Brightness.dark;

const backgroundLight = Color(0xFFF6EFEC);
const onBackgroundLight = backgroundDark;

const backgroundDark = Color(0xFF1A1313);
const onBackgroundDark = Colors.white;

TextTheme buildTextTheme(BuildContext context, Color onBackground) {
  return TextTheme(
    headline6: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w900,
      color: onBackground,
    ),
    headline5: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w900,
      color: primary,
    ),
    headline4: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w900,
      color: onBackground,
    ),
    headline3: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w900,
      color: onBackground,
    ),
    headline2: const TextStyle(),
    headline1: const TextStyle(),
    caption: const TextStyle(),
    button: const TextStyle(
      color: onPrimary,
      fontFamily: 'Mulish',
      fontWeight: FontWeight.bold,
    ),
    bodyText1: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    bodyText2: const TextStyle(),
    overline: const TextStyle(),
    subtitle1: const TextStyle(),
    subtitle2: const TextStyle(),
  ).apply(fontFamily: 'Mulish');
}

ThemeData buildLight(BuildContext context) {
  final textTheme = buildTextTheme(context, onBackgroundLight);

  return ThemeData.from(
    colorScheme: const ColorScheme(
      brightness: brightnessLight,
      primary: primary,
      primaryContainer: primaryVariant,
      secondary: secondary,
      secondaryContainer: secondaryVariant,
      surface: surface,
      background: backgroundLight,
      error: error,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onSurface: onSurface,
      onBackground: onBackgroundLight,
      onError: onError,
    ),
    textTheme: textTheme,
  ).copyWith(
    appBarTheme: appBarTheme(context, backgroundLight, onBackgroundLight),
  );
}

ThemeData buildDark(BuildContext context) {
  final textTheme = buildTextTheme(context, onBackgroundDark);

  return ThemeData.from(
    colorScheme: const ColorScheme(
      brightness: brightnessDark,
      primary: primary,
      primaryContainer: primaryVariant,
      secondary: secondary,
      secondaryContainer: secondaryVariant,
      surface: surface,
      background: backgroundDark,
      error: error,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onSurface: onSurface,
      onBackground: onBackgroundDark,
      onError: onError,
    ),
    textTheme: textTheme,
  ).copyWith(
    appBarTheme: appBarTheme(context, backgroundDark, onBackgroundDark),
  );
}

AppBarTheme appBarTheme(
  BuildContext context,
  Color background,
  Color onBackground,
) {
  return AppBarTheme(
    elevation: 0.0,
    backgroundColor: background,
    foregroundColor: secondary,
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w900,
      color: onBackground,
      fontFamily: 'Mulish',
    ),
  );
}
