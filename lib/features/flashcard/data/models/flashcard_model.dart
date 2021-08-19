import 'package:dartz/dartz.dart';
import 'package:easy_language/features/flashcard/domain/entities/flashcard.dart';
import 'package:language_picker/languages.dart';

class FlashcardModel extends Flashcard {
  const FlashcardModel({
    required bool isTurned,
    required int wordIndex,
    required Language wordLanguage,
  }) : super(
          isTurned: isTurned,
          wordIndex: wordIndex,
          wordLanguage: wordLanguage,
        );

  static const isTurnedId = 'isTurned';
  static const wordIndexId = 'wordIndex';
  static const wordLanguageId = 'wordLanguage';

  factory FlashcardModel.fromMap(
    Map<dynamic, dynamic> flashcardMap,
  ) {
    return FlashcardModel(
      isTurned: cast(flashcardMap[isTurnedId]) ?? false,
      wordIndex: cast(flashcardMap[wordIndexId]) ?? 0,
      wordLanguage: Language.fromIsoCode(
        cast(flashcardMap[wordLanguageId]) ?? Languages.english.isoCode,
      ),
    );
  }

  FlashcardModel copyWithMap(Map<dynamic, dynamic> map) {
    return FlashcardModel.fromMap({...toMap(), ...map});
  }

  Map<dynamic, dynamic> toMap() {
    return {
      isTurnedId: isTurned,
      wordIndexId: wordIndex,
      wordLanguageId: wordLanguage.isoCode,
    };
  }
}
