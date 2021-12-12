import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:language_picker/languages.dart';

class DictionaryModel extends Dictionary {
  const DictionaryModel({
    required int id,
    required List<Word> words,
    required Language language,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          words: words,
          language: language,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory DictionaryModel.fromMap(Map jsonMap) {
    //TODO: fix casting
    try {
      final Map data = cast(jsonMap['data']);
      final Map dictMap = cast(data[Dictionary.dictionaryIdId]);
      final Language lang = Language.fromIsoCode(cast(dictMap[languageId]));
      final List<Map> wordsList = cast(data[Dictionary.wordsId]);
      final List<Word> words = wordsList.map((e) => Word.fromMap(e)).toList();
      final int id = cast(dictMap[idId]);
      final DateTime createdAt = DateTime.tryParse(
        cast(dictMap[createdAtId]),
      ) ??
          DateTime.now();
      final DateTime updatedAt = DateTime.tryParse(
        cast(dictMap[updatedAtId]),
      ) ??
          DateTime.now();

      return DictionaryModel(
        words: words,
        id: id,
        language: lang,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      print(e);
      throw Error();
    }
    // final Map<Language, List<Word>> dicts = dictionaryMap.map(
    //   (key, value) {
    //     final isoKey = Language.fromIsoCode(cast(key));
    //     final List<Word> valueMap = [
    //       ...value.map(
    //         (e) {
    //           return Word.fromMap(cast(e));
    //         },
    //       )
    //     ];
    //
    //     return MapEntry(isoKey, valueMap);
    //   },
    // );
  }

  Map<dynamic, dynamic> toMap() {
    final Map map = {
      idId: this.id,
      languageId: language,
      createdAtId: createdAt,
      updatedAtId: updatedAt,
    };
    // final Map<dynamic, dynamic> map = dictionaries.map(
    //   (key, value) => MapEntry(
    //     key.isoCode,
    //     [...value.map((e) => e.toMap())],
    //   ),
    // );

    return map;
  }
}
