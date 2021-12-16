import 'package:dartz/dartz.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';

class UserModel extends User {
  const UserModel({
    bool isStartup = true,
    ThemeMode themeMode = ThemeMode.system,
    required Language nativeLanguage,
    required String email,
    required String token,
    int currentDictionaryId = 0,
  }) : super(
          themeMode: themeMode,
          isStartup: isStartup,
          nativeLanguage: nativeLanguage,
          email: email,
          currentDictionaryId: currentDictionaryId,
          token: token,
        );

  /// Takes map and returns a [UserModel]
  /// Map's object should be a basic type (int, string, bool) and NOT enum
  factory UserModel.fromMap(Map map) {
    final Map data = cast(map['data']['user']);
    return UserModel(
      isStartup: cast(data[User.isStartupId]) ?? true,
      themeMode: mapStringToThemeMode(cast(data[User.themeModeId])),
      email: cast(data[User.emailId]) ?? '',
      currentDictionaryId: cast(data[User.currentDictionaryIdId]) ?? 0,
      token: cast(map[User.tokenId]),
      nativeLanguage: Language.fromIsoCode(
        cast(data[User.nativeLanguageId]) ?? Languages.english.isoCode,
      ),
    );
  }

  UserModel copyWithMap(Map map) {
    return UserModel.fromMap({...toMap(), ...map});
  }

  Map toMap() => {
        User.isStartupId: isStartup,
        User.themeModeId: mapThemeModeToString(themeMode),
        User.nativeLanguageId: nativeLanguage.isoCode,
        User.emailId: email,
        User.currentDictionaryIdId: currentDictionaryId,
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

  static String mapThemeModeToString(ThemeMode theme) {
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
