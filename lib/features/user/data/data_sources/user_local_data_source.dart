import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

abstract class SettingsLocalDataSource {
  Future<UserModel> getCachedUser();

  Future cacheUser(UserModel userToCache);

  Future clearUser();
}

class UserLocalDataSourceImpl implements SettingsLocalDataSource {
  final Box userBox;

  UserLocalDataSourceImpl({required this.userBox});

  @override
  Future<UserModel> getCachedUser() {
    try {
      if (userBox.isEmpty) {
        throw CacheException();
      } else {
        final dbMap = userBox.toMap();
        return Future.value(UserModel.fromMap(dbMap));
      }
    } catch (e) {
      Logger().e(e);
      throw CacheException();
    }
  }

  @override
  Future cacheUser(UserModel settingsToCache) async {
    try {
      await userBox.putAll(settingsToCache.toMap());
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
