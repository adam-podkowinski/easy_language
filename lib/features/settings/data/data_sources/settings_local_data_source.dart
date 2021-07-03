import 'package:easy_language/features/settings/data/models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getLocalSettings();
  Future<void> cacheSettings(SettingsModel settingsToCache);
}

// TODO: implement SettingsLocalDataSource
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  @override
  Future<void> cacheSettings(SettingsModel settingsToCache) {
    // TODO: implement cacheSettings
    throw UnimplementedError();
  }

  @override
  Future<SettingsModel> getLocalSettings() {
    // TODO: implement getLocalSettings
    throw UnimplementedError();
  }
}