import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';

class UserModel extends User {
  const UserModel({
    required int id,
    required Language nativeLanguage,
    required String email,
    required DateTime updatedAt,
    int currentDictionaryId = 0,
    ThemeMode themeMode = ThemeMode.system,
    bool isRegisteredWithGoogle = false,
  }) : super(
          id: id,
          themeMode: themeMode,
          nativeLanguage: nativeLanguage,
          email: email,
          currentDictionaryId: currentDictionaryId,
          updatedAt: updatedAt,
          isRegisteredWithGoogle: isRegisteredWithGoogle,
        );

  /// Takes map and returns a [UserModel]
  factory UserModel.fromMap(Map userData) {
    return UserModel(
      id: cast(userData[idId]) ?? 0,
      themeMode: mapStringToThemeMode(cast(userData[User.themeModeId])),
      email: cast(userData[User.emailId]) ?? '',
      currentDictionaryId: cast(userData[User.currentDictionaryIdId]) ?? 0,
      updatedAt: DateTime.parse(cast(userData[updatedAtId])),
      isRegisteredWithGoogle:
          cast(userData[User.isRegisteredWithGoogleId]) ?? false,
      nativeLanguage: Language.fromIsoCode(
        cast(userData[User.nativeLanguageId]) ?? Languages.english.isoCode,
      ),
    );
  }

  UserModel copyWithMap(Map map) {
    return UserModel.fromMap({...toMap(), ...map});
  }

  Map<String, dynamic> toMap() => {
        idId: this.id,
        updatedAtId: updatedAt.toIso8601String(),
        User.themeModeId: mapThemeModeToString(themeMode),
        User.nativeLanguageId: nativeLanguage.isoCode,
        User.emailId: email,
        User.currentDictionaryIdId: currentDictionaryId,
        User.isRegisteredWithGoogleId: isRegisteredWithGoogle,
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

  static String mapThemeModeToString(ThemeMode? theme) {
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
