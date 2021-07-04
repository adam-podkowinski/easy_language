import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:flutter/material.dart';

class SettingsModel extends Settings {
  bool initial = false;
  SettingsModel({
    bool isStartup = true,
    ThemeMode themeMode = ThemeMode.system,
    this.initial = false,
  }) : super(themeMode: themeMode, isStartup: isStartup);

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      isStartup: map['isStartup'] as bool,
      themeMode: mapStringToThemeMode(map['themeMode'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'isStartup': isStartup,
        'themeMode': mapThemeModeToString(themeMode),
      };

  static ThemeMode mapStringToThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String mapThemeModeToString(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
