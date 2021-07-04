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
  final bool? isStartup;
  final ThemeMode? themeMode;

  const ChangeSettingsEvent({this.isStartup, this.themeMode});

  @override
  List<Object?> get props => [isStartup, themeMode];
}
