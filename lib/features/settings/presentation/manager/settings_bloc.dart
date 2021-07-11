import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/use_cases/change_settings.dart';
import 'package:easy_language/features/settings/domain/use_cases/get_settings.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final ChangeSettings changeSettings;

  SettingsBloc({required this.getSettings, required this.changeSettings})
      : super(SettingsInitial());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is GetSettingsEvent) {
      final settings = await getSettings(NoParams());
      yield* settings.fold(
        (l) async* {
          if (l is SettingsFailure) {
            yield SettingsInitialized(settings: l.settings, failure: l);
          }
        },
        (r) async* {
          yield SettingsInitialized(settings: r);
        },
      );
    } else if (event is ChangeSettingsEvent) {
      final settings = await changeSettings(
        SettingsParams(settingsMap: event.changedSettings),
      );
      yield* settings.fold(
        (l) async* {
          if (l is SettingsFailure) {
            yield SettingsInitialized(settings: l.settings, failure: l);
          }
        },
        (r) async* {
          yield SettingsInitialized(settings: r);
        },
      );
    }
  }
}

class SingletonSettingsBloc extends SettingsBloc {
  SingletonSettingsBloc({
    required GetSettings getSettings,
    required ChangeSettings changeSettings,
  }) : super(getSettings: getSettings, changeSettings: changeSettings);
}
