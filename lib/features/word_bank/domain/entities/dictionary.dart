import 'package:easy_language/core/word.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

// class WordBank extends Equatable {
//   final Map<Language, Dictionary> dictionaries;
//
//   const WordBank({required this.dictionaries});
//
//   @override
//   List<Object?> get props => [dictionaries];
// }

class Dictionary extends Equatable {
  final List<Word> words;
  final bool wordsFetched;
  final Language language;
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;

  static const wordsId = 'words';
  static const dictionaryIdId = 'dictionary';

  const Dictionary({
    required this.words,
    required this.language,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.wordsFetched = false,
  });

  @override
  List<Object?> get props => [words, language, id];
}
