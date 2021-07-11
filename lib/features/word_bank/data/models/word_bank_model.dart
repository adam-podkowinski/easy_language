import 'package:dartz/dartz.dart';
import 'package:easy_language/features/word_bank/data/models/word_model.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:language_picker/languages.dart';

class WordBankModel extends WordBank {
  const WordBankModel({
    required Map<Language, List<WordModel>> dictionaries,
  }) : super(dictionaries: dictionaries);

  factory WordBankModel.fromMap(
    Map<dynamic, dynamic> dictionariesMap,
  ) {
    final Map<Language, List<WordModel>> dicts = dictionariesMap.map(
      (key, value) {
        final isoKey = Language.fromIsoCode(cast(key));
        final List<WordModel> valueMap = [
          ...value.map(
            (e) {
              return WordModel.fromMap(cast(e));
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
        [...value.map((e) => WordModel.wordToMap(e))],
      ),
    );

    return map;
  }
}
