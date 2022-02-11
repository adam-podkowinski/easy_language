import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:easy_language/features/word_bank/domain/repositories/dictionary_repository.dart';
import 'package:easy_language/injection_container.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool loading = true;

  bool get loggedIn => user != null;

  final UserRepository userRepository;

  User? user;

  UserFailure? userFailure;

  Map createMap = {};

  UserProvider({
    required this.userRepository,
  });

  String get themeModeString => loggedIn
      ? UserModel.mapThemeModeToString(user?.themeMode)
      : cast(createMap[User.themeModeId]) ?? 'System';

  void _prepareMethod() {
    loading = true;
    userFailure = null;
    notifyListeners();
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

    final userEither = await userRepository.initUser();
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

    if (!loggedIn) {
      createMap.addAll(changedSettings);
      _finishMethod();
      return;
    }

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

  Future googleSignIn() async {
    _prepareMethod();

    final userEither = await userRepository.googleSignIn();

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

    final registerMap = {...registerForm, ...createMap};

    final userEither = await userRepository.register(formMap: registerMap);

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

    sl<DictionaryRepository>().logout();

    if (failure is UserFailure) {
      userFailure = failure;
    }

    _finishMethod();
  }

  Future removeAccount({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    _prepareMethod();
    final successful =
        await userRepository.removeAccount(email: email, password: password);
    if (successful) {
      user = null;
      sl<DictionaryRepository>().logout();
    } else {
      userFailure = UserUnauthenticatedFailure(
        "Couldn't remove an account. Contact support at: $contactAddress",
      );
    }
    _finishMethod();
  }
}
