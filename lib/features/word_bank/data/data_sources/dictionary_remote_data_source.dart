import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/word_bank/data/models/dictionary_model.dart';

abstract class DictionaryRemoteDataSource {
  Future<DictionariesModel> fetchDictionaries();

  Future<DictionaryModel> fetchCurrentDictionary();

  Future<DictionaryModel> addDictionary();

  Future saveDictionaries(DictionariesModel wordBankToCache);

  Future saveCurrentDictionary(DictionaryModel dictionaryToCache);
}

class DictionaryRemoteDataSourceImpl implements DictionaryRemoteDataSource {
  @override
  Future<DictionaryModel> fetchCurrentDictionary() {
    // TODO: implement fetchCurrentLanguage
    throw UnimplementedError();
  }

  @override
  Future<DictionariesModel> fetchDictionaries() {
    // TODO: implement fetchWordBank
    throw UnimplementedError();
  }

  @override
  Future saveCurrentDictionary(DictionaryModel dictionary) {
    // TODO: implement saveCurrentLanguage
    throw UnimplementedError();
  }

  @override
  Future saveDictionaries(DictionariesModel wordBankToCache) {
    // TODO: implement saveWordBank
    throw UnimplementedError();
  }

  @override
  Future<DictionaryModel> addDictionary() {
    // TODO: implement addDictionary
    throw UnimplementedError();
  }
}
