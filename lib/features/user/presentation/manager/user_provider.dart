import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool loading = true;

  bool get loggedIn => user != null;

  final UserRepository userRepository;

  User? user;

  UserFailure? userFailure;

  UserProvider({
    required this.userRepository,
  });

  String get themeModeString =>
      UserModel.mapThemeModeToString(user?.themeMode ?? ThemeMode.system);

  void _prepareMethod() {
    loading = true;
    userFailure = null;
  }

  void _finishMethod() {
    loading = false;
    notifyListeners();
  }

  void clearError() {
    userFailure = null;
  }

  Future initUser() async {
    _prepareMethod();

    final userEither = await userRepository.getUser();
    userEither.fold(
      (l) {
        if (l is UserFailure) {
          userFailure = l;
        }
      },
      (r) => user = r,
    );

    _finishMethod();
  }

  Future editUser(Map<String, dynamic> changedSettings) async {
    _prepareMethod();

    final userEither = await userRepository.editUser(
      userMap: changedSettings,
    );
    userEither.fold(
      (l) {
        if (l is UserFailure) {
          userFailure = l;
        }
      },
      (r) => user = r,
    );

    _finishMethod();
  }

  Future login(Map<String, dynamic> loginForm) async {
    _prepareMethod();

    final userEither = await userRepository.login(formMap: loginForm);

    userEither.fold(
      (l) {
        if (l is UserFailure) {
          userFailure = l;
        }
      },
      (r) => user = r,
    );

    _finishMethod();
  }

  Future register(Map<String, String> registerForm) async {
    _prepareMethod();

    final userEither = await userRepository.register(formMap: registerForm);

    userEither.fold(
      (l) {
        if (l is UserFailure) {
          userFailure = l;
        }
      },
      (r) => user = r,
    );

    _finishMethod();
  }

  Future logout() async {
    _prepareMethod();

    final Failure? failure = await userRepository.logout();
    user = null;

    if (failure is UserFailure) {
      userFailure = failure;
    }

    _finishMethod();
  }
}
