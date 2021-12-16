import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';

class User extends Equatable {
  final bool isStartup;
  final ThemeMode themeMode;
  final Language nativeLanguage;
  final String email;
  final int currentDictionaryId;
  final String token;

  const User({
    required this.isStartup,
    required this.themeMode,
    required this.nativeLanguage,
    required this.email,
    required this.token,
    this.currentDictionaryId = 0,
  });

  static const isStartupId = 'isStartup';
  static const nativeLanguageId = 'nativeLanguage';
  static const emailId = 'email';
  static const currentDictionaryIdId = 'current_dictionary_id';
  static const tokenId = 'token';

  static const themeModeId = 'themeMode';
  static const darkThemeId = 'Dark';
  static const lightThemeId = 'Light';
  static const systemThemeId = 'System';
  static const availableThemesIds = [systemThemeId, lightThemeId, darkThemeId];

  @override
  List<Object?> get props => [isStartup, themeMode, nativeLanguage];
}
