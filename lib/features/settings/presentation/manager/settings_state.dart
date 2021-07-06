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
  final SettingsCacheFailure? failure;

  const SettingsInitialized({required this.settings, this.failure});

  @override
  List<Object?> get props => [settings, failure];
}
