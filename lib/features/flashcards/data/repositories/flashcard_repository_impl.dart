import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/flashcards/data/data_sources/flashcard_local_data_source.dart';
import 'package:easy_language/features/flashcards/data/models/flashcard_model.dart';
import 'package:easy_language/features/flashcards/domain/entities/flashcard.dart';
import 'package:easy_language/features/flashcards/domain/repositories/flashcard_repository.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:language_picker/languages.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  bool _initial = true;
  late FlashcardModel? _flashcard;
  final FlashcardLocalDataSource localDataSource;

  FlashcardRepositoryImpl({required this.localDataSource});

  // TODO: finish getNextFlashcard
  @override
  Future<Either<Failure, Flashcard>> getNextFlashcard(
    WordBank wordBank,
    Language language,
  ) async {
    try {
      if (_flashcard != null) {
        if (language == _flashcard!.wordLanguage) {}
      }
    } catch (_) {
      return Left(FlashcardGetFailure());
    }
    return Right(_flashcard!);
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
