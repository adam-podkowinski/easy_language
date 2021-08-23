import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/flashcard/domain/entities/flashcard.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:language_picker/languages.dart';

abstract class FlashcardRepository {
  Future<Either<Failure, Flashcard>> getNextFlashcard(
    WordBank wordBank, {
    Language? language,
    bool? init,
  });

  Future<Either<Failure, Flashcard>> turnCurrentFlashcard();

  Future<Either<Failure, Flashcard?>> fetchFlashcardRemotely();

  Future saveFlashcard();
}
