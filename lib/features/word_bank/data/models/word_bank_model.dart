import 'package:easy_language/features/word_bank/data/models/word_model.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:language_picker/languages.dart';

class WordBankModel extends WordBank {
  const WordBankModel({
    required Map<Language, List<WordModel>> dictionaries,
  }) : super(dictionaries: dictionaries);

  factory WordBankModel.fromMap(
    Map<String, List<Map<String, String>>> dictionariesMap,
  ) {
    final Map<Language, List<WordModel>> dicts = dictionariesMap.map(
      (key, value) => MapEntry(
        Language.fromIsoCode(key),
        [...value.map((e) => WordModel.fromMap(e))],
      ),
    );

    return WordBankModel(dictionaries: dicts);
  }

  Map<String, List<Map<String, String>>> toMap() {
    final Map<String, List<Map<String, String>>> map = dictionaries.map(
      (key, value) => MapEntry(
        key.isoCode,
        [...value.map((e) => WordModel.wordToMap(e))],
      ),
    );

    return map;
  }
}
