import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';
import 'package:easy_language/features/settings/domain/use_cases/change_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late ChangeSettings usecase;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    usecase = ChangeSettings(mockSettingsRepository);
  });

  test(
    'should change the settings with provided options through repository',
    () async {
      const tNewThemeMode = ThemeMode.dark;
      const tNewIsStartup = false;
      const tNewSettings = Settings(
        themeMode: tNewThemeMode,
        isStartup: tNewIsStartup,
      );

      when(
        () => mockSettingsRepository.changeSettings(
          settingsMap: any(named: 'settingsMap'),
        ),
      ).thenAnswer((_) async => const Right(tNewSettings));

      await usecase(
        const SettingsParams(
          settingsMap: {themeModeId: tNewThemeMode, isStartupId: tNewIsStartup},
        ),
      );

      verify(
        () => mockSettingsRepository.changeSettings(
          settingsMap: {
            themeModeId: tNewThemeMode,
            isStartupId: tNewIsStartup,
          },
        ),
      );
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );
}
