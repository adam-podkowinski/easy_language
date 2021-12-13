import 'package:dartz/dartz.dart';
import 'package:easy_language/features/user/domain/entities/settings.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';

class SettingsModel extends User {
  const SettingsModel({
    bool isStartup = true,
    ThemeMode themeMode = ThemeMode.system,
    required Language nativeLanguage,
  }) : super(
          themeMode: themeMode,
          isStartup: isStartup,
          nativeLanguage: nativeLanguage,
        );

  /// Takes map and returns a [SettingsModel]
  /// Map's object should be a basic type (int, string, bool) and NOT enum
  factory SettingsModel.fromMap(Map map) {
    return SettingsModel(
      isStartup: cast(map[User.isStartupId]) ?? true,
      themeMode: mapStringToThemeMode(cast(map[User.themeModeId])),
      nativeLanguage: Language.fromIsoCode(
        cast(map[User.nativeLanguageId]) ?? Languages.english.isoCode,
      ),
    );
  }

  SettingsModel copyWithMap(Map map) {
    return SettingsModel.fromMap({...toMap(), ...map});
  }

  Map toMap() => {
        User.isStartupId: isStartup,
        User.themeModeId: mapThemeModeToString(themeMode),
        User.nativeLanguageId: nativeLanguage.isoCode,
      };

  static ThemeMode mapStringToThemeMode(String? theme) {
    switch (theme) {
      case User.lightThemeId:
        return ThemeMode.light;
      case User.darkThemeId:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String mapThemeModeToString(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.light:
        return User.lightThemeId;
      case ThemeMode.dark:
        return User.darkThemeId;
      default:
        return User.systemThemeId;
    }
  }
}
