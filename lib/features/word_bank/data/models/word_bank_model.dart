import 'package:dartz/dartz.dart';
import 'package:easy_language/features/word_bank/data/models/word_model.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:language_picker/languages.dart';

class WordBankModel extends WordBank {
  const WordBankModel({
    required Map<Language, List<WordModel>> dictionaries,
  }) : super(dictionaries: dictionaries);

  factory WordBankModel.fromMap(
    Map<String, dynamic> dictionariesMap,
  ) {
    final Map<Language, List<WordModel>> dicts = dictionariesMap.map(
      (key, value) {
        final isoKey = Language.fromIsoCode(key);
        final List<WordModel> valueMap = [
          ...value.map((e) => WordModel.fromMap(cast(e)))
        ];

        return MapEntry(isoKey, valueMap);
      },
    );

    return WordBankModel(dictionaries: dicts);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = dictionaries.map(
      (key, value) => MapEntry(
        key.isoCode,
        [...value.map((e) => WordModel.wordToMap(e))],
      ),
    );

    return map;
  }
}
