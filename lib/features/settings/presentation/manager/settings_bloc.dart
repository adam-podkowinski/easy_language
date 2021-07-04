import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/use_cases/change_settings.dart';
import 'package:easy_language/features/settings/domain/use_cases/get_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final ChangeSettings changeSettings;

  SettingsBloc({required this.getSettings, required this.changeSettings})
      : super(SettingsInitial());

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is GetSettingsEvent) {
      final settings = await getSettings(NoParams());
      yield* settings.fold(
        (l) async* {
          yield SettingsInitialized(settings: (l as CacheFailure).settings);
        },
        (r) async* {
          yield SettingsInitialized(settings: r);
        },
      );
    }

    if (event is ChangeSettingsEvent) {
      final settings = await changeSettings(
        SettingsParams(themeMode: event.themeMode, isStartup: event.isStartup),
      );
      yield* settings.fold(
        (l) async* {
          yield SettingsInitialized(settings: (l as CacheFailure).settings);
        },
        (r) async* {
          yield SettingsInitialized(settings: r);
        },
      );
    }
  }
}
