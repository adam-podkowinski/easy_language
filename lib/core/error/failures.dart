import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnknownFailure extends Failure {}

class CacheFailure extends Failure {
  final Settings settings;
  CacheFailure(this.settings);

  @override
  List<Object?> get props => [settings];
}
