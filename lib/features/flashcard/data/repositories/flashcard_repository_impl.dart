import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/flashcard/data/data_sources/flashcard_local_data_source.dart';
import 'package:easy_language/features/flashcard/data/data_sources/flashcard_remote_data_source.dart';
import 'package:easy_language/features/flashcard/data/models/flashcard_model.dart';
import 'package:easy_language/features/flashcard/domain/entities/flashcard.dart';
import 'package:easy_language/features/flashcard/domain/repositories/flashcard_repository.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:language_picker/languages.dart';
import 'package:logger/logger.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  FlashcardModel? _flashcard;

  final FlashcardLocalDataSource localDataSource;
  final FlashcardRemoteDataSource remoteDataSource;

  FlashcardRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Flashcard>> getNextFlashcard(
    WordBank wordBank, {
    Language? language,
    bool? init,
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
      final Language? flashcardLang = language ?? _flashcard?.wordLanguage;
      int flashcardIndex = 0;
      bool isTurned = _flashcard?.isTurned ?? false;

      if (flashcardLang == null) {
        throw Exception('flashcard lang is equal to null');
      }

      // Assure there are words available to become a flashcard
      if (wordBank.dictionaries[flashcardLang]?.isEmpty ?? true) {
        throw Exception(
          'word bank dictionary at flashcardLang is empty or null',
        );
      }

      // Assign a starting index
      // If we get flashcard for a first time we want it to have the same index
      // When it got cached (otherwise we proceed with a next one)
      if (init ?? false) {
        flashcardIndex = _flashcard?.wordIndex ?? 0;
      } else {
        flashcardIndex = (_flashcard?.wordIndex ?? -1) + 1;
        isTurned = false;
      }

      // If we changed language we want to reset index from cached flashcard
      if (_flashcard?.wordLanguage != flashcardLang) {
        flashcardIndex = 0;
        isTurned = false;
      }

      // If we go to the end of a word list we want to start over
      if ((wordBank.dictionaries[flashcardLang]?.length ?? -1) <=
          flashcardIndex) {
        flashcardIndex = 0;
      }

      _flashcard = FlashcardModel(
        isTurned: isTurned,
        wordIndex: flashcardIndex,
        wordLanguage: flashcardLang,
      );

      try {
        localDataSource.cacheCurrentFlashcard(_flashcard!);
        if (!(init ?? false)) {
          remoteDataSource.saveFlashcard(_flashcard!);
        }
      } catch (_) {}

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
      localDataSource.cacheCurrentFlashcard(_flashcard!);
      remoteDataSource.saveFlashcard(_flashcard!);
      return Right(_flashcard!);
    } catch (_) {
      return Left(FlashcardTurnFailure());
    }
  }

  @override
  Future<Either<Failure, Flashcard?>> fetchFlashcardRemotely() async {
    try {
      _flashcard = await remoteDataSource.fetchFlashcard();
      localDataSource.cacheCurrentFlashcard(_flashcard!);
      return Right(_flashcard);
    } catch (_) {
      _flashcard = null;
      return Left(FlashcardGetFailure());
    }
  }

  @override
  Future saveFlashcard() async {
    try {
      if (_flashcard != null) {
        localDataSource.cacheCurrentFlashcard(_flashcard!);
        await remoteDataSource.saveFlashcard(_flashcard!);
      }
    } catch (_) {
      return;
    }
  }
}
