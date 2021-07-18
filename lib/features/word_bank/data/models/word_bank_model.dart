import 'package:dartz/dartz.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:language_picker/languages.dart';

class WordBankModel extends WordBank {
  const WordBankModel({
    required Map<Language, List<Word>> dictionaries,
  }) : super(dictionaries: dictionaries);

  factory WordBankModel.fromMap(
    Map<dynamic, dynamic> dictionariesMap,
  ) {
    final Map<Language, List<Word>> dicts = dictionariesMap.map(
      (key, value) {
        final isoKey = Language.fromIsoCode(cast(key));
        final List<Word> valueMap = [
          ...value.map(
            (e) {
              return Word.fromMap(cast(e));
            },
          )
        ];

        return MapEntry(isoKey, valueMap);
      },
    );

    return WordBankModel(dictionaries: dicts);
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> map = dictionaries.map(
      (key, value) => MapEntry(
        key.isoCode,
        [...value.map((e) => Word.wordToMap(e))],
      ),
    );

    return map;
  }
}
