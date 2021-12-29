import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:language_picker/languages.dart';
import 'package:logger/logger.dart';

class DictionaryModel extends Dictionary {
  final bool shouldFetchWords;

  const DictionaryModel({
    required int id,
    required List<Word> words,
    required Language language,
    required DateTime updatedAt,
    required this.shouldFetchWords,
  }) : super(
          id: id,
          words: words,
          language: language,
          updatedAt: updatedAt,
        );

  factory DictionaryModel.fromMap(Map jsonMap, {required bool shouldFetch}) {
    try {
      final Map data = cast(jsonMap['data']);
      final Map dictMap = cast(data[Dictionary.dictionaryIdId]);
      final Language lang = Language.fromIsoCode(cast(dictMap[languageId]));
      final List wordsList = cast(data[Dictionary.wordsId]) ?? [];
      final List<Word> words = wordsList
          .map(
            (e) => Word.fromMap(cast(e)),
          )
          .toList();
      final int id = cast(dictMap[idId]);
      final DateTime updatedAt = DateTime.tryParse(
            cast(dictMap[updatedAtId]),
          ) ??
          DateTime.now();

      return DictionaryModel(
        words: words,
        id: id,
        language: lang,
        updatedAt: updatedAt,
        shouldFetchWords: shouldFetch,
      );
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  Map wordsToMap() {
    return {
      "words": words.map((e) => e.toMap()).toList(),
    };
  }

  Map toMap() {
    return {
      'data': {
        Dictionary.dictionaryIdId: {
          idId: this.id,
          languageId: language.isoCode,
          updatedAtId: updatedAt.toIso8601String(),
        },
        ...wordsToMap(),
      },
    };
  }

  DictionaryModel copyWith(Map map, {bool? shouldFetch}) {
    return DictionaryModel.fromMap(
      {...toMap(), ...map},
      shouldFetch: shouldFetch ?? shouldFetchWords,
    );
  }
}
