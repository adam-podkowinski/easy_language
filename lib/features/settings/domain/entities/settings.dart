import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Settings extends Equatable {
  final bool isStartup;
  final ThemeMode themeMode;

  const Settings({required this.isStartup, required this.themeMode});

  static const isStartupId = 'isStartup';
  static const themeModeId = 'themeMode';
  static const darkThemeId = 'Dark';
  static const lightThemeId = 'Light';
  static const systemThemeId = 'System';
  static const availableThemesIds = [systemThemeId, lightThemeId, darkThemeId];

  @override
  List<Object?> get props => [isStartup, themeMode];
}
