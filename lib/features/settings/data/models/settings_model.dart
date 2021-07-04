import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
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
      isStartup: cast(map[isStartupId]) ?? true,
      themeMode: mapStringToThemeMode(cast(map[themeModeId])),
    );
  }

  SettingsModel newFromMap(Map<String, Object> map) {
    final Map<String, Object> newMap = {...toMap(), ...map};
    return SettingsModel.fromMap(newMap);
  }

  Map<String, Object> toMap() => {
        'isStartup': isStartup,
        'themeMode': mapThemeModeToString(themeMode),
      };

  static ThemeMode mapStringToThemeMode(String? theme) {
    switch (theme) {
      case lightThemeId:
        return ThemeMode.light;
      case darkThemeId:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String mapThemeModeToString(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.light:
        return lightThemeId;
      case ThemeMode.dark:
        return darkThemeId;
      default:
        return systemThemeId;
    }
  }
}
