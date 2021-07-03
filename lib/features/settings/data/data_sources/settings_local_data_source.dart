import 'dart:convert';

import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getLocalSettings();

  Future<void> cacheSettings(SettingsModel settingsToCache);
}

const cachedSettingsString = 'settings';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SettingsModel> getLocalSettings() {
    final jsonString = sharedPreferences.getString(cachedSettingsString);
    if (jsonString != null) {
      return Future.value(
        SettingsModel.fromMap(jsonDecode(jsonString) as Map<String, dynamic>),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheSettings(SettingsModel settingsToCache) {
    try {
      return sharedPreferences.setString(
        cachedSettingsString,
        jsonEncode(
          settingsToCache.toMap(),
        ),
      );
    } on Exception {
      throw CacheException();
    }
  }
}
