import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/dictionaries/data/models/dictionary_model.dart';

abstract class DictionariesRemoteDataSource {
  Future<DictionariesModel> fetchDictionaries();

  Future<DictionaryModel> fetchCurrentDictionary();

  Future<DictionaryModel> addDictionary();

  Future saveDictionaries(DictionariesModel dictionariesToCache);

  Future saveCurrentDictionary(DictionaryModel dictionaryToCache);
}

class DictionariesRemoteDataSourceImpl implements DictionariesRemoteDataSource {
  @override
  Future<DictionaryModel> fetchCurrentDictionary() {
    // TODO: implement fetchCurrentLanguage
    throw UnimplementedError();
  }

  @override
  Future<DictionariesModel> fetchDictionaries() {
    // TODO: implement fetchDictionaries
    throw UnimplementedError();
  }

  @override
  Future saveCurrentDictionary(DictionaryModel dictionary) {
    // TODO: implement saveCurrentLanguage
    throw UnimplementedError();
  }

  @override
  Future saveDictionaries(DictionariesModel dictionariesToCache) {
    // TODO: implement saveDictionaries
    throw UnimplementedError();
  }

  @override
  Future<DictionaryModel> addDictionary() {
    // TODO: implement addDictionary
    throw UnimplementedError();
  }
}
