// TODO: write tests for FlashcardRepositoryImpl
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/flashcards/data/data_sources/flashcard_local_data_source.dart';
import 'package:easy_language/features/flashcards/data/models/flashcard_model.dart';
import 'package:easy_language/features/flashcards/data/repositories/flashcard_repository_impl.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockFlashcardLocalDataSource extends Mock
    implements FlashcardLocalDataSource {}

void main() {
  late final FlashcardRepositoryImpl repository;
  late final MockFlashcardLocalDataSource flashcardLocalDataSource;

  setUpAll(() {
    flashcardLocalDataSource = MockFlashcardLocalDataSource();
    repository = FlashcardRepositoryImpl(
      localDataSource: flashcardLocalDataSource,
    );
    registerFallbackValue(
      FlashcardModel(
          isTurned: false, wordIndex: 0, wordLanguage: Languages.polish),
    );
  });

  final tFlashcard = FlashcardModel.fromMap(
    cast(
      jsonDecode(
        fixture('flashcard.json'),
      ),
    ),
  );

  final tFlashcardIndexOne = FlashcardModel.fromMap(
    cast(
      jsonDecode(
        fixture('flashcard_index_one.json'),
      ),
    ),
  );

  final tFlashcardIndexOutOfBounds = FlashcardModel.fromMap(
    cast(
      jsonDecode(
        fixture('flashcard_index_out_of_bounds.json'),
      ),
    ),
  );

  group('getNextFlashcard', () {
    final WordBankModel tWordBank = WordBankModel.fromMap(cast(
      jsonDecode(
        fixture('word_bank.json'),
      ),
    ));

    test(
      'should return a valid flashcard when there is one cached',
      () async {
        when(() => flashcardLocalDataSource.getLocalFlashcard()).thenAnswer(
          (_) async => tFlashcard,
        );
        when(() => flashcardLocalDataSource.cacheCurrentFlashcard(any()))
            .thenAnswer(
          (_) => Future.value(),
        );

        final result = await repository.getNextFlashcard(tWordBank);
        expect(result, Right(tFlashcard));

        final secondResult = await repository.getNextFlashcard(tWordBank);
        expect(secondResult, Right(tFlashcardIndexOne));
      },
    );

    test(
      '''
      should return a valid flashcard when there is one cached 
      but its index is out of bounds''',
      () async {
        when(() => flashcardLocalDataSource.getLocalFlashcard()).thenAnswer(
          (_) async => tFlashcardIndexOutOfBounds,
        );
        when(() => flashcardLocalDataSource.cacheCurrentFlashcard(any()))
            .thenAnswer(
          (_) => Future.value(),
        );

        final result = await repository.getNextFlashcard(tWordBank);
        expect(result, Right(tFlashcard));

        final secondResult = await repository.getNextFlashcard(tWordBank);
        expect(secondResult, Right(tFlashcardIndexOne));
      },
    );

    test(
      '''
      should return a valid flashcard when there is nothing cached
      and there are words in word bank''',
      () async {
        when(() => flashcardLocalDataSource.getLocalFlashcard())
            .thenThrow(CacheException());
        when(() => flashcardLocalDataSource.cacheCurrentFlashcard(any()))
            .thenAnswer(
          (_) => Future.value(),
        );

        final result = await repository.getNextFlashcard(tWordBank);
        expect(result, Right(tFlashcard));

        final secondResult = await repository.getNextFlashcard(tWordBank);
        expect(secondResult, Right(tFlashcardIndexOne));
      },
    );
  });
}
