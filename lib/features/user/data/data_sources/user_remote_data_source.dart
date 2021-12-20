import 'package:easy_language/features/user/data/models/user_model.dart';

abstract class SettingsRemoteDataSource {
  Future<UserModel> fetchUser();

  Future saveUser(UserModel settingsToCache);

  Future<UserModel> editUser(UserModel userToEdit);
}

//TODO: implement methods
class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  @override
  Future<UserModel> fetchUser() async {
    throw UnimplementedError();
  }

  @override
  Future saveUser(UserModel settingsToCache) async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> editUser(UserModel userToEdit) {
    // TODO: implement editUser
    throw UnimplementedError();
  }
}
