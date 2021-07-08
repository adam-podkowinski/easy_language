part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  @override
  List<Object?> get props => [];
}

class SettingsInitialized extends SettingsState {
  final Settings settings;
  final SettingsFailure? failure;

  const SettingsInitialized({required this.settings, this.failure});

  String get themeModeString =>
      SettingsModel.mapThemeModeToString(settings.themeMode);

  @override
  List<Object?> get props => [settings, failure];
}
