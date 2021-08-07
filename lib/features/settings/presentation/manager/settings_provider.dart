import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool loading = true;

  final SettingsRepository settingsRepository;

  Settings settings = const Settings(
    isStartup: false,
    themeMode: ThemeMode.system,
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

    loading = false;
    notifyListeners();
    return settings;
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

    loading = false;
    notifyListeners();
  }
}
