import 'package:dartz/dartz.dart';
import 'package:easy_language/features/flashcards/domain/entities/flashcard.dart';
import 'package:language_picker/languages.dart';

class FlashcardModel extends Flashcard {
  const FlashcardModel({
    required bool isTurned,
    required String wordId,
    required Language wordLanguage,
  }) : super(
          isTurned: isTurned,
          wordId: wordId,
          wordLanguage: wordLanguage,
        );

  static const isTurnedId = 'isTurned';
  static const wordIdId = 'wordId';
  static const wordLanguageId = 'wordLanguage';

  factory FlashcardModel.fromMap(
    Map<dynamic, dynamic> flashcardMap,
  ) {
    return FlashcardModel(
      isTurned: cast(flashcardMap[isTurnedId]) ?? false,
      wordId: cast(flashcardMap[wordIdId]) ?? '',
      wordLanguage: Language.fromIsoCode(
        cast(flashcardMap[wordLanguageId]) ?? 'en-US',
      ),
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      isTurnedId: isTurned,
      wordIdId: wordId,
      wordLanguageId: wordLanguage.isoCode,
    };
  }
}
