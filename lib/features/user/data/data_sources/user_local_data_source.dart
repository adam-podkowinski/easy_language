import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

abstract class SettingsLocalDataSource {
  Future<UserModel> getLocalSettings();

  Future<void> cacheSettings(UserModel settingsToCache);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Box settingsBox;

  SettingsLocalDataSourceImpl({required this.settingsBox});

  @override
  Future<UserModel> getLocalSettings() {
    try {
      if (settingsBox.isEmpty) {
        throw CacheException();
      } else {
        final dbMap = settingsBox.toMap();
        return Future.value(UserModel.fromMap(dbMap));
      }
    } catch (e) {
      Logger().e(e);
      throw CacheException();
    }
  }

  @override
  Future<void> cacheSettings(UserModel settingsToCache) async {
    try {
      await settingsBox.putAll(settingsToCache.toMap());
    } catch (e) {
      Logger().e(e);
      throw CacheException();
    }
  }
}
