import 'package:dartz/dartz.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/edit_word_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/mock_word_bank_repository.dart';

void main() {
  late final MockWordBankRepository repository;
  late final EditWordList usecase;

  setUp(() {
    repository = MockWordBankRepository();
    usecase = EditWordList(repository);
    registerFallbackValue<Language>(Languages.polish);
  });

  test(
    'should forward a call to edit a word list in a word bank to a repository',
    () async {
      final tLanguageFrom = Languages.polish;
      final tLanguageTo = Languages.spanish;
      final tNewWord = Word(
        wordForeign: 'gracias',
        wordTranslation: 'polskagurom',
        editDate: DateTime.now(),
      );
      final tNewWordList = [tNewWord];
      final tWordBank = WordBank(dictionaries: {
        tLanguageTo: tNewWordList,
      });

      when(
        () => repository.editWordsList(
          languageFrom: any(named: 'languageFrom'),
          languageTo: any(named: 'languageTo'),
          newWordList: any(named: 'newWordList'),
        ),
      ).thenAnswer(
        (_) async => Right(tWordBank),
      );

      await usecase(
        EditWordListParams(
          languageFrom: tLanguageFrom,
          languageTo: tLanguageTo,
          newWordList: tNewWordList,
        ),
      );

      verify(
        () => repository.editWordsList(
          languageFrom: tLanguageFrom,
          languageTo: tLanguageTo,
          newWordList: tNewWordList,
        ),
      );

      verifyNoMoreInteractions(repository);
    },
  );
}
