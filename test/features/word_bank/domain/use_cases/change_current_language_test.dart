import 'package:dartz/dartz.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/change_current_language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/mock_word_bank_repository.dart';

void main() {
  late ChangeCurrentLanguage usecase;
  late MockWordBankRepository repository;

  setUp(() {
    repository = MockWordBankRepository();
    usecase = ChangeCurrentLanguage(repository);
    registerFallbackValue<Language>(Languages.polish);
  });

  test(
    'should forward a call to change current learning language to a repository',
    () async {
      final tNewLanguage = Languages.azerbaijani;
      when(
        () => repository.changeCurrentLanguage(any()),
      ).thenAnswer(
        (_) async => Right(tNewLanguage),
      );

      await usecase(ChangeCurrentLanguageParams(language: tNewLanguage));

      verify(() => repository.changeCurrentLanguage(tNewLanguage));
      verifyNoMoreInteractions(repository);
    },
  );
}
