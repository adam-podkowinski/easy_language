import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';
import 'package:equatable/equatable.dart';

class ChangeSettings implements Usecase<Settings, SettingsParams> {
  final SettingsRepository repository;

  ChangeSettings(this.repository);

  @override
  Future<Either<Failure, Settings>> call(SettingsParams params) async {
    return repository.changeSettings(
      settingsMap: params.settingsMap,
    );
  }
}

class SettingsParams extends Equatable {
  final Map<String, dynamic> settingsMap;

  const SettingsParams({required this.settingsMap});

  @override
  List<Object?> get props => [settingsMap];
}
