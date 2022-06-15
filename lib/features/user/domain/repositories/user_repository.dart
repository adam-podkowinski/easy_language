import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';

// TODO: implement refresh token
abstract class UserRepository {
  UserModel? user;
  bool get loggedIn;

  Future<InfoFailure?> editUser({required Map userMap});

  Future<InfoFailure?> initUser();

  Future<InfoFailure?> fetchUser();

  Future<InfoFailure?> googleSignIn();

  Future<InfoFailure?> login({required Map formMap});

  Future<InfoFailure?> register({required Map formMap});

  Future<InfoFailure?> logout();

  Future<InfoFailure?> removeAccount({
    required String email,
    required String password,
  });
}
