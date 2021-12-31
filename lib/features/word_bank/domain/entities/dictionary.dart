import 'package:easy_language/core/word.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class Dictionary extends Equatable {
  final List<Word> words;
  final bool wordsFetched;
  final Language language;
  final int id;
  final DateTime updatedAt;
  final int flashcardId;

  static const wordsId = 'words';
  static const dictionaryIdId = 'dictionary';
  static const flashcardIdId = 'flashcard_id';

  const Dictionary({
    required this.words,
    required this.language,
    required this.id,
    required this.updatedAt,
    required this.flashcardId,
    this.wordsFetched = false,
  });

  @override
  List<Object?> get props => [
        id,
        words,
        wordsFetched,
        language,
        updatedAt,
        flashcardId,
      ];
}
