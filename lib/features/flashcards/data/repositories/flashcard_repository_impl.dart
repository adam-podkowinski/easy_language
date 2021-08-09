import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/flashcards/data/data_sources/flashcard_local_data_source.dart';
import 'package:easy_language/features/flashcards/data/models/flashcard_model.dart';
import 'package:easy_language/features/flashcards/domain/entities/flashcard.dart';
import 'package:easy_language/features/flashcards/domain/repositories/flashcard_repository.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:language_picker/languages.dart';
import 'package:logger/logger.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  bool _initial = true;
  FlashcardModel? _flashcard;
  final FlashcardLocalDataSource localDataSource;

  FlashcardRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Flashcard>> getNextFlashcard(
    WordBank wordBank, {
    Language? language,
  }) async {
    if (wordBank.dictionaries.isEmpty) {
      return Left(FlashcardGetFailure());
    }

    try {
      _flashcard ??= await localDataSource.getLocalFlashcard();
    } catch (_) {
      Logger().d('Flashcard not cached');
    }

    try {
      Language flashcardLang = language ??
          _flashcard?.wordLanguage ??
          wordBank.dictionaries.keys.first;

      // Assign a starting index
      // If we get flashcard for a first time we want it to have the same index
      // When it got cached (otherwise we proceed with a next one)
      int flashcardIndex = 0;
      if (_initial) {
        flashcardIndex = _flashcard?.wordIndex ?? 0;
      } else {
        flashcardIndex = (_flashcard?.wordIndex ?? -1) + 1;
      }

      // Assure there are words available to become a flashcard
      if (wordBank.dictionaries[flashcardLang]?.isEmpty ?? true) {
        flashcardLang = wordBank.dictionaries.keys.firstWhere(
          (lang) => wordBank.dictionaries[lang]?.isNotEmpty ?? false,
          orElse: () => throw Exception(),
        );
      }

      // If we changed language we want to reset index from cached flashcard
      if (_flashcard?.wordLanguage != flashcardLang) {
        flashcardIndex = 0;
      }

      // If we go to the end of a word list we want to start over
      if ((wordBank.dictionaries[flashcardLang]?.length ?? -1) <=
          flashcardIndex) {
        flashcardIndex = 0;
      }

      _flashcard = FlashcardModel(
        isTurned: false,
        wordIndex: flashcardIndex,
        wordLanguage: flashcardLang,
      );

      await localDataSource.cacheCurrentFlashcard(_flashcard!);

      _initial = false;

      return Right(_flashcard!);
    } catch (_) {
      return Left(FlashcardGetFailure());
    }
  }

  @override
  Future<Either<Failure, Flashcard>> turnCurrentFlashcard() async {
    try {
      _flashcard = _flashcard!.copyWithMap({
        FlashcardModel.isTurnedId: !_flashcard!.isTurned,
      });
      await localDataSource.cacheCurrentFlashcard(_flashcard!);
      return Right(_flashcard!);
    } catch (_) {
      return Left(FlashcardTurnFailure());
    }
  }
}
