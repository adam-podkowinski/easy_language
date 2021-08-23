import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';

class SettingsProvider extends ChangeNotifier {
  bool loading = true;

  final SettingsRepository settingsRepository;

  Settings settings = Settings(
    isStartup: false,
    themeMode: ThemeMode.system,
    nativeLanguage: Languages.english,
  );

  SettingsFailure? settingsFailure;

  SettingsProvider({
    required this.settingsRepository,
  });

  String get themeModeString =>
      SettingsModel.mapThemeModeToString(settings.themeMode);

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
