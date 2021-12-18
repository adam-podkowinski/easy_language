import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool loading = true;

  final UserRepository settingsRepository;

  User? user;

  UserFailure? settingsFailure;

  UserProvider({
    required this.settingsRepository,
  });

  String get themeModeString =>
      UserModel.mapThemeModeToString(user?.themeMode ?? ThemeMode.system);

  void _prepareMethod() {
    loading = true;
    settingsFailure = null;
  }

  void _finishMethod() {
    loading = false;
    notifyListeners();
  }

  Future initSettings() async {
    _prepareMethod();

    final settingsEither = await settingsRepository.getUser();
    settingsEither.fold(
      (l) {
        if (l is UserFailure) {
          settingsFailure = l;
        }
      },
      (r) => user = r,
    );

    _finishMethod();
  }

  Future changeSettings(Map<String, dynamic> changedSettings) async {
    _prepareMethod();

    final settingsEither = await settingsRepository.editUser(
      userMap: changedSettings,
    );
    settingsEither.fold(
      (l) {
        if (l is UserFailure) {
          settingsFailure = l;
        }
      },
      (r) => user = r,
    );

    _finishMethod();
  }

  Future fetchSettings() async {
    _prepareMethod();

    final settingsEither = await settingsRepository.fetchUser();
    settingsEither.fold(
      (l) {
        if (l is UserFailure) {
          settingsFailure = l;
        }
      },
      (r) => user = r,
    );

    _finishMethod();
  }

  Future saveSettings() async {
    await settingsRepository.cacheUser();
  }
}
