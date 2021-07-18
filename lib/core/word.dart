import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final String wordForeign;
  final String wordTranslation;

  const Word({required this.wordForeign, required this.wordTranslation});

  static const wordForeignId = 'wordForeign';
  static const wordTranslationId = 'wordTranslation';

  factory Word.fromMap(Map<dynamic, dynamic> map) {
    return Word(
      wordForeign: cast(map[Word.wordForeignId]) ?? '',
      wordTranslation: cast(map[Word.wordTranslationId]) ?? '',
    );
  }

  Word copyWithMap(Map<dynamic, dynamic> map) {
    final newMap = {...toMap(), ...map};
    return Word.fromMap(newMap);
  }

  Map<dynamic, dynamic> toMap() => {
        Word.wordForeignId: wordForeign,
        Word.wordTranslationId: wordTranslation,
      };

  static Map<dynamic, dynamic> wordToMap(Word word) => {
        Word.wordForeignId: word.wordForeign,
        Word.wordTranslationId: word.wordTranslation,
      };

  @override
  List<Object?> get props => [wordForeign, wordTranslation];
}
