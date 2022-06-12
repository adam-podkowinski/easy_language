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
  final String refreshToken;
  final DateTime updatedAt;
  final bool isRegisteredWithGoogle;

  const User({
    required this.id,
    required this.themeMode,
    required this.nativeLanguage,
    required this.email,
    required this.token,
    required this.refreshToken,
    required this.updatedAt,
    this.currentDictionaryId = 0,
    this.isRegisteredWithGoogle = false,
  });

  static const nativeLanguageId = 'nativeLanguage';
  static const emailId = 'email';
  static const currentDictionaryIdId = 'currentDictionaryId';
  static const tokenId = 'accessToken';
  static const refreshTokenId = 'refreshToken';
  static const isRegisteredWithGoogleId = 'isRegisteredWithGoogle';

  static const themeModeId = 'themeMode';
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
        refreshToken,
        currentDictionaryId,
        isRegisteredWithGoogle,
        email,
        updatedAt,
      ];
}
