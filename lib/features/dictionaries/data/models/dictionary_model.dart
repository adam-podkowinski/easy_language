import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/dictionaries/domain/entities/dictionary.dart';
import 'package:language_picker/languages.dart';

class DictionaryModel extends Dictionary {
  final bool shouldFetchWords;

  const DictionaryModel({
    required int id,
    required List<Word> words,
    required Language language,
    required DateTime updatedAt,
    required int flashcardId,
    required this.shouldFetchWords,
  }) : super(
          id: id,
          words: words,
          language: language,
          updatedAt: updatedAt,
          flashcardId: flashcardId,
        );

  factory DictionaryModel.fromMap(Map jsonMap, {required bool shouldFetch}) {
    final Language lang = Language.fromIsoCode(cast(jsonMap[languageId]));
    final List wordsList = cast(jsonMap[Dictionary.wordsId]) ?? [];
    final List<Word> words = wordsList
        .map(
          (e) => Word.fromMap(cast(e)),
        )
        .toList();
    final int id = cast(jsonMap[idId]);
    final int flashcardId = cast(jsonMap[Dictionary.flashcardIdId] ?? 0) ?? 0;
    final DateTime updatedAt = DateTime.tryParse(
          cast(jsonMap[updatedAtId]),
        ) ??
        DateTime.now();

    return DictionaryModel(
      words: words,
      id: id,
      language: lang,
      updatedAt: updatedAt,
      shouldFetchWords: shouldFetch,
      flashcardId: flashcardId,
    );
  }

  Map toMap() => {
        ..._dictMap(),
        'words': _wordsList(),
      };

  DictionaryModel copyWith(Map dictMap, {bool? shouldFetch, Map? wordMap}) =>
      DictionaryModel.fromMap(
        {
          ..._dictMap(),
          ...dictMap,
          'words': wordMap ?? _wordsList(),
        },
        shouldFetch: shouldFetch ?? shouldFetchWords,
      );

  // Helper methods
  List _wordsList() => words.map((e) => e.toMap()).toList();

  Map _dictMap() => {
        idId: this.id,
        languageId: language.isoCode,
        updatedAtId: updatedAt.toIso8601String(),
        Dictionary.flashcardIdId: flashcardId,
      };
}
