import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChangeSettings implements Usecase<Settings, SettingsParams> {
  final SettingsRepository repository;

  ChangeSettings(this.repository);

  @override
  Future<Either<Failure, Settings>> call(SettingsParams params) async {
    return repository.changeSettings(
      isStartup: params.isStartup,
      themeMode: params.themeMode,
    );
  }
}

class SettingsParams extends Equatable {
  final bool? isStartup;
  final ThemeMode? themeMode;

  const SettingsParams({this.isStartup, this.themeMode});

  @override
  List<Object?> get props => [isStartup, themeMode];
}
