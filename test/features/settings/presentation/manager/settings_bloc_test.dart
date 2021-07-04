import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/use_cases/change_settings.dart';
import 'package:easy_language/features/settings/domain/use_cases/get_settings.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSettings extends Mock implements GetSettings {}

class MockChangeSettings extends Mock implements ChangeSettings {}

void main() {
  late SettingsBloc bloc;
  late MockGetSettings mockGetSettings;
  late MockChangeSettings mockChangeSettings;

  SettingsBloc getBloc() => SettingsBloc(
        getSettings: mockGetSettings,
        changeSettings: mockChangeSettings,
      );

  setUp(() {
    mockGetSettings = MockGetSettings();
    mockChangeSettings = MockChangeSettings();
    bloc = getBloc();
    registerFallbackValue(
      const SettingsParams(settingsMap: {}),
    );
    registerFallbackValue(NoParams());
  });

  test('initial state should be SettingsInitial', () {
    expect(bloc.state, SettingsInitial());
  });

  group('GetSettingsEvent', () {
    const Settings settings = SettingsModel(themeMode: ThemeMode.dark);

    void setUpGetSettingsFailure() =>
        when(() => mockGetSettings(any())).thenAnswer(
          (_) async => Left(SettingsCacheFailure(settings)),
        );
    void setUpGetSettingsSuccess() =>
        when(() => mockGetSettings(any())).thenAnswer(
          (_) async => const Right(settings),
        );

    blocTest(
      '''
      should emit [SettingsLoading, SettingsInitialized(Settings)] 
      when the data is gotten successfully''',
      build: () {
        setUpGetSettingsSuccess();
        return getBloc();
      },
      act: (SettingsBloc tBloc) {
        tBloc.add(const GetSettingsEvent());
      },
      expect: () {
        return [
          SettingsLoading(),
          const SettingsInitialized(settings: settings),
        ];
      },
    );

    blocTest(
      '''
      should emit [SettingsLoading, SettingsInitialized(Settings, Failure)] 
      when there was an error while caching''',
      build: () {
        setUpGetSettingsFailure();
        return getBloc();
      },
      act: (SettingsBloc tBloc) {
        tBloc.add(const GetSettingsEvent());
      },
      expect: () {
        return [
          SettingsLoading(),
          SettingsInitialized(
            settings: settings,
            failure: SettingsCacheFailure(settings),
          ),
        ];
      },
    );
  });
}
