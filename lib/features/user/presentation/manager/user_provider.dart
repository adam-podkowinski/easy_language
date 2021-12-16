import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';

class UserProvider extends ChangeNotifier {
  bool loading = true;

  final UserRepository settingsRepository;

  User settings = User(
    isStartup: false,
    themeMode: ThemeMode.system,
    token: '',
    nativeLanguage: Languages.english,
    email: '',
  );

  SettingsFailure? settingsFailure;

  UserProvider({
    required this.settingsRepository,
  });

  String get themeModeString =>
      UserModel.mapThemeModeToString(settings.themeMode);

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

    final settingsEither = await settingsRepository.getSettings();
    settingsEither.fold(
      (l) {
        if (l is SettingsFailure) {
          settingsFailure = l;
          settings = l.settings;
        }
      },
      (r) => settings = r,
    );

    _finishMethod();
  }

  Future changeSettings(Map<String, dynamic> changedSettings) async {
    _prepareMethod();

    final settingsEither = await settingsRepository.changeSettings(
      settingsMap: changedSettings,
    );
    settingsEither.fold(
      (l) {
        if (l is SettingsFailure) {
          settingsFailure = l;
          settings = l.settings;
        }
      },
      (r) => settings = r,
    );

    _finishMethod();
  }

  Future fetchSettings() async {
    _prepareMethod();

    final settingsEither = await settingsRepository.fetchSettingsRemotely();
    settingsEither.fold(
      (l) {
        if (l is SettingsFailure) {
          settingsFailure = l;
          settings = l.settings;
        }
      },
      (r) => settings = r,
    );

    _finishMethod();
  }

  Future saveSettings() async {
    await settingsRepository.saveSettings();
  }
}
