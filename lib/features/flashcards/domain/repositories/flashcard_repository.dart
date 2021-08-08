import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/flashcards/domain/entities/flashcard.dart';

abstract class FlashcardRepository {
  Future<Either<Failure, Flashcard>> getNextFlashcard();

  Future<Either<Failure, Flashcard>> turnCurrentFlashcard();
}
