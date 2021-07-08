import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnknownFailure extends Failure {}

abstract class SettingsFailure extends Failure {
  final Settings settings;

  SettingsFailure(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SettingsCacheFailure extends SettingsFailure {
  SettingsCacheFailure(Settings settings) : super(settings);
}

class SettingsGetFailure extends SettingsFailure {
  SettingsGetFailure(Settings settings) : super(settings);
}
