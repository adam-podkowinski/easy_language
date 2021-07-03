import 'package:dartz/dartz.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';
import 'package:easy_language/features/settings/domain/use_cases/get_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late GetSettings usecase;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    usecase = GetSettings(mockSettingsRepository);
  });

  const tSettings = Settings();

  test(
    'should get settings from the repository',
    () async {
      when(() => mockSettingsRepository.getSettings())
          .thenAnswer((_) async => const Right(tSettings));

      final result = await usecase(NoParams());

      expect(result, const Right(tSettings));
      verify(() => mockSettingsRepository.getSettings());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );
}
