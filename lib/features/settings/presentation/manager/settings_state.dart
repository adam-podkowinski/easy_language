part of 'settings_bloc.dart';

abstract class SettingsState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {}

class SettingsInitialized extends SettingsState {
  final Settings settings;

  const SettingsInitialized({required this.settings});
}
