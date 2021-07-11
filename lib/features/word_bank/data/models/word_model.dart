import 'package:dartz/dartz.dart';
import 'package:easy_language/features/word_bank/domain/entities/word.dart';

class WordModel extends Word {
  const WordModel({
    required String wordForeign,
    required String wordTranslation,
  }) : super(wordForeign: wordForeign, wordTranslation: wordTranslation);

  factory WordModel.fromMap(Map<dynamic, dynamic> map) {
    return WordModel(
      wordForeign: cast(map[Word.wordForeignId]) ?? '',
      wordTranslation: cast(map[Word.wordTranslationId]) ?? '',
    );
  }

  WordModel copyWithMap(Map<dynamic, dynamic> map) {
    final newMap = {...toMap(), ...map};
    return WordModel.fromMap(newMap);
  }

  Map<dynamic, dynamic> toMap() => {
        Word.wordForeignId: wordForeign,
        Word.wordTranslationId: wordTranslation,
      };

  static Map<dynamic, dynamic> wordToMap(Word word) => {
        Word.wordForeignId: word.wordForeign,
        Word.wordTranslationId: word.wordTranslation,
      };
}
