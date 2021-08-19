import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';

class Settings extends Equatable {
  final bool isStartup;
  final ThemeMode themeMode;
  final Language nativeLanguage;

  const Settings({
    required this.isStartup,
    required this.themeMode,
    required this.nativeLanguage,
  });

  static const isStartupId = 'isStartup';
  static const themeModeId = 'themeMode';
  static const darkThemeId = 'Dark';
  static const lightThemeId = 'Light';
  static const systemThemeId = 'System';
  static const nativeLanguageId = 'nativeLanguage';
  static const availableThemesIds = [systemThemeId, lightThemeId, darkThemeId];

  @override
  List<Object?> get props => [isStartup, themeMode, nativeLanguage];
}
