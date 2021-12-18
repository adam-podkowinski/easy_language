import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

abstract class SettingsLocalDataSource {
  Future<UserModel> getCachedUser();

  Future cacheUser(UserModel settingsToCache);

  Future clearUser();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Box settingsBox;

  SettingsLocalDataSourceImpl({required this.settingsBox});

  @override
  Future<UserModel> getCachedUser() {
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
  Future<void> cacheUser(UserModel settingsToCache) async {
    try {
      await settingsBox.putAll(settingsToCache.toMap());
    } catch (e) {
      Logger().e(e);
      throw CacheException();
    }
  }

  @override
  Future clearUser() {
    // TODO: implement clearUser
    throw UnimplementedError();
  }
}
