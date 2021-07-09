import 'package:dartz/dartz.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:flutter/material.dart';

class SettingsModel extends Settings {
  const SettingsModel({
    bool isStartup = true,
    ThemeMode themeMode = ThemeMode.system,
  }) : super(themeMode: themeMode, isStartup: isStartup);

  /// Takes map and returns a [SettingsModel]
  /// Map's object should be a basic type (int, string, bool) and NOT ENUM
  factory SettingsModel.fromMap(Map<String, Object> map) {
    return SettingsModel(
      isStartup: cast(map[Settings.isStartupId]) ?? true,
      themeMode: mapStringToThemeMode(cast(map[Settings.themeModeId])),
    );
  }

  SettingsModel copyWithMap(Map<String, Object> map) {
    final Map<String, Object> newMap = {...toMap(), ...map};
    return SettingsModel.fromMap(newMap);
  }

  Map<String, Object> toMap() => {
        'isStartup': isStartup,
        'themeMode': mapThemeModeToString(themeMode),
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
