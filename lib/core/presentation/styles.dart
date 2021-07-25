import 'package:flutter/material.dart';

class CustomTheme {
  static const primary = Color(0xFF1889f8);
  static const primaryVariant = Color(0xff1863f8);
  static const secondary = Color(0xffe58f3b);
  static const secondaryVariant = Color(0xfff85f18);
  static const surface = primary;
  static const error = Colors.deepOrange;
  static const onPrimary = Colors.white;
  static const onSecondary = Colors.white;
  static const onSurface = Colors.white;
  static const onError = Colors.white;

  //Depending on theming
  static const brightnessLight = Brightness.light;
  static const brightnessDark = Brightness.dark;

  static const backgroundLight = Colors.white;
  static const onBackgroundLight = backgroundDark;

  static const backgroundDark = Color(0xFF191919);
  static const onBackgroundDark = Colors.white;

  static TextTheme buildTextTheme(BuildContext context, Color onBackground) {
    return TextTheme(
      headline6: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: onBackground,
        fontFamily: 'Mulish',
      ),
      headline5: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: primary,
      ),
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
    ).apply(fontFamily: 'Mulish');
  }

  static ThemeData buildLight(BuildContext context) {
    final textTheme = buildTextTheme(context, onBackgroundLight);

    return ThemeData.from(
      colorScheme: const ColorScheme(
        brightness: brightnessLight,
        primary: primary,
        primaryVariant: primaryVariant,
        secondary: secondary,
        secondaryVariant: secondaryVariant,
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

  static ThemeData buildDark(BuildContext context) {
    final textTheme = buildTextTheme(context, onBackgroundDark);

    return ThemeData.from(
      colorScheme: const ColorScheme(
        brightness: brightnessDark,
        primary: primary,
        primaryVariant: primaryVariant,
        secondary: secondary,
        secondaryVariant: secondaryVariant,
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

  static AppBarTheme appBarTheme(
    BuildContext context,
    Color background,
    Color onBackground,
  ) {
    return AppBarTheme(
      backwardsCompatibility: false,
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
}
