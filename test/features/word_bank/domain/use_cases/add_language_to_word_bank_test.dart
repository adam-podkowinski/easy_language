import 'package:dartz/dartz.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/add_language_to_word_bank.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/mock_word_bank_repository.dart';

void main() {
  late final MockWordBankRepository repository;
  late final AddLanguageToWordBank usecase;

  setUp(() {
    repository = MockWordBankRepository();
    usecase = AddLanguageToWordBank(repository);
    registerFallbackValue<Language>(Languages.polish);
  });

  test(
    'should forward a call to add a language to a word bank to a repository',
    () async {
      final tNewLanguage = Languages.polish;
      const tNewWord =
          Word(wordForeign: 'polska', wordTranslation: 'polskagurom');
      const tWordList = [tNewWord];
      final tWordBank = WordBank(dictionaries: {
        tNewLanguage: tWordList,
      });

      when(
        () => repository.addLanguageToWordBank(any(),
            initialWords: any(named: 'initialWords')),
      ).thenAnswer(
        (_) async => Right(tWordBank),
      );

      await usecase(
        AddLanguageToWordBankParams(
          tNewLanguage,
          initialWords: tWordList,
        ),
      );

      verify(
        () => repository.addLanguageToWordBank(
          tNewLanguage,
          initialWords: tWordList,
        ),
      );

      verifyNoMoreInteractions(repository);
    },
  );
}
