import 'package:dartz/dartz.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';

class SettingsModel extends Settings {
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
  factory SettingsModel.fromMap(Map<dynamic, dynamic> map) {
    return SettingsModel(
      isStartup: cast(map[Settings.isStartupId]) ?? true,
      themeMode: mapStringToThemeMode(cast(map[Settings.themeModeId])),
      nativeLanguage: Language.fromIsoCode(
        cast(map[Settings.nativeLanguageId]) ?? Languages.english.isoCode,
      ),
    );
  }

  SettingsModel copyWithMap(Map<dynamic, dynamic> map) {
    return SettingsModel.fromMap({...toMap(), ...map});
  }

  Map<dynamic, dynamic> toMap() => {
        Settings.isStartupId: isStartup,
        Settings.themeModeId: mapThemeModeToString(themeMode),
        Settings.nativeLanguageId: nativeLanguage.isoCode,
      };

  static ThemeMode mapStringToThemeMode(String? theme) {
    switch (theme) {
      case Settings.lightThemeId:
        return ThemeMode.light;
      case Settings.darkThemeId:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String mapThemeModeToString(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.light:
        return Settings.lightThemeId;
      case ThemeMode.dark:
        return Settings.darkThemeId;
      default:
        return Settings.systemThemeId;
    }
  }
}
