import 'package:dartz/dartz.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_word_bank.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/mock_word_bank_repository.dart';

void main() {
  late final MockWordBankRepository repository;
  late final GetWordBank usecase;

  setUp(() {
    repository = MockWordBankRepository();
    usecase = GetWordBank(repository);
  });

  final tLanguage = Languages.english;
  final tWordBank = WordBank(dictionaries: {
    tLanguage: const [Word(wordForeign: 'lolo', wordTranslation: 'lol')],
  });

  test(
    'should get a word bank from the repository',
    () async {
      when(
        () => repository.getWordBank(),
      ).thenAnswer(
        (_) async => Right(tWordBank),
      );

      final result = await usecase(NoParams());

      expect(result, equals(Right(tWordBank)));
      verify(() => repository.getWordBank());
      verifyNoMoreInteractions(repository);
    },
  );
}
