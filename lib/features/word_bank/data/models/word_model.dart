import 'package:easy_language/features/word_bank/domain/entities/word.dart';

class WordModel extends Word {
  const WordModel({
    required String wordForeign,
    required String wordTranslation,
  }) : super(wordForeign: wordForeign, wordTranslation: wordTranslation);

  factory WordModel.fromMap(Map<String, String> map) {
    return WordModel(
      wordForeign: map[Word.wordForeignId] ?? '',
      wordTranslation: map[Word.wordTranslationId] ?? '',
    );
  }

  WordModel copyWithMap(Map<String, String> map) {
    final newMap = {...toMap(), ...map};
    return WordModel.fromMap(newMap);
  }

  Map<String, String> toMap() => {
        'wordForeign': wordForeign,
        'wordTranslation': wordTranslation,
      };

  static Map<String, String> wordToMap(Word word) => {
        'wordForeign': word.wordForeign,
        'wordTranslation': word.wordTranslation,
      };
}
