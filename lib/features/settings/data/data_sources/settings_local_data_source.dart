import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:hive/hive.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getLocalSettings();

  Future<void> cacheSettings(SettingsModel settingsToCache);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Box settingsBox;

  SettingsLocalDataSourceImpl({required this.settingsBox});

  @override
  Future<SettingsModel> getLocalSettings() {
    try {
      if (settingsBox.isEmpty) {
        throw CacheException();
      } else {
        final dbMap = settingsBox.toMap();
        return Future.value(SettingsModel.fromMap(dbMap));
      }
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheSettings(SettingsModel settingsToCache) async {
    try {
      await settingsBox.putAll(settingsToCache.toMap());
    } on Exception {
      throw CacheException();
    }
  }
}
