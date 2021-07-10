import 'package:dartz/dartz.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_current_language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/mock_word_bank_repository.dart';

void main() {
  late final MockWordBankRepository repository;
  late final GetCurrentLanguage usecase;

  setUp(() {
    repository = MockWordBankRepository();
    usecase = GetCurrentLanguage(repository);
  });

  final tLanguage = Languages.english;

  test(
    'should get current word bank language from the repository',
    () async {
      when(
        () => repository.getCurrentLanguage(),
      ).thenAnswer(
        (_) async => Right(tLanguage),
      );

      final result = await usecase(NoParams());

      expect(result, equals(Right(tLanguage)));
      verify(() => repository.getCurrentLanguage());
      verifyNoMoreInteractions(repository);
    },
  );
}
