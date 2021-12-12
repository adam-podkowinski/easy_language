import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/flashcard/domain/entities/flashcard.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';

abstract class FlashcardRepository {
  Future<Either<Failure, Flashcard>> getNextFlashcard(
    Dictionary dictionary, {
    bool? init,
  });

  Future<Either<Failure, Flashcard>> turnCurrentFlashcard();

  Future<Either<Failure, Flashcard?>> fetchFlashcardRemotely();

  Future saveFlashcard();
}
