import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';

class User extends Equatable {
  final int id;
  final ThemeMode themeMode;
  final Language nativeLanguage;
  final String email;
  final int currentDictionaryId;
  final String token;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.themeMode,
    required this.nativeLanguage,
    required this.email,
    required this.token,
    required this.updatedAt,
    this.currentDictionaryId = 0,
  });

  static const nativeLanguageId = 'native_language';
  static const emailId = 'email';
  static const currentDictionaryIdId = 'current_dictionary_id';
  static const tokenId = 'token';

  static const themeModeId = 'theme_mode';
  static const darkThemeId = 'Dark';
  static const lightThemeId = 'Light';
  static const systemThemeId = 'System';
  static const availableThemesIds = [systemThemeId, lightThemeId, darkThemeId];

  @override
  List<Object?> get props => [
        id,
        themeMode,
        nativeLanguage,
        token,
        currentDictionaryId,
        email,
        updatedAt,
      ];
}