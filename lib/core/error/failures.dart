import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnknownFailure extends Failure {}

class CacheFailure extends Failure {
  final Settings _settings;
  CacheFailure(this._settings);

  @override
  List<Object?> get props => [_settings];
}
