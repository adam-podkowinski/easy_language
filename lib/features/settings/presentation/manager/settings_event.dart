part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class GetSettingsEvent extends SettingsEvent {
  const GetSettingsEvent();

  @override
  List<Object?> get props => [];
}

class ChangeSettingsEvent extends SettingsEvent {
  final Map<String, Object> changedSettings;

  const ChangeSettingsEvent({required this.changedSettings});

  @override
  List<Object?> get props => [changedSettings];
}
