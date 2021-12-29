import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/word_bank/data/models/dictionary_model.dart';
import 'package:hive/hive.dart';
import 'package:language_picker/languages.dart';
import 'package:logger/logger.dart';

abstract class DictionaryLocalDataSource {
  Future<DictionariesModel> getLocalDictionaries();

  Future<Language> getLocalCurrentLanguage();

  Future cacheDictionaries(DictionariesModel wordBankModel);

  Future cacheCurrentDictionary(DictionaryModel? wordBankModel);
}

class DictionaryLocalDataSourceImpl implements DictionaryLocalDataSource {
  @override
  Future cacheCurrentDictionary(DictionaryModel? wordBankModel) {
    // TODO: implement cacheCurrentDictionary
    throw UnimplementedError();
  }

  @override
  Future cacheDictionaries(DictionariesModel wordBankModel) {
    // TODO: implement cacheDictionaries
    throw UnimplementedError();
  }

  @override
  Future<Language> getLocalCurrentLanguage() {
    // TODO: implement getLocalCurrentLanguage
    throw UnimplementedError();
  }

  @override
  Future<DictionariesModel> getLocalDictionaries() {
    try {
      if (wordBankBox.isEmpty) {
        return Future.value({});
      } else {
        final dbMap = wordBankBox.toMap();
        final DictionariesModel dictionaries = {};
        for (final Map dictMap in dbMap['dictionaries']) {
          final lang = Language.fromIsoCode(cast(dictMap[languageId]));
          dictionaries[lang] = DictionaryModel.fromMap(
            dictMap,
            shouldFetch: false,
          );
        }
        return Future.value(dictionaries);
      }
    } catch (e) {
      Logger().e(e);
      throw CacheException();
    }
  }

  final Box wordBankBox;

  DictionaryLocalDataSourceImpl({required this.wordBankBox});
//
//  @override
//  Future cacheDictionaries(WordBankModel wordBankModel) async {
//    try {
//      await wordBankBox.put(cachedWordBankId, wordBankModel.toMap());
//    } catch (e) {
//      Logger().e(e);
//      throw CacheException();
//    }
//  }
//
//  @override
//  Future<WordBankModel> getLocalWordBank() async {
//    try {
//      if (wordBankBox.isEmpty) {
//        throw CacheException();
//      } else {
//        final dbMap = wordBankBox.get(cachedWordBankId);
//        return WordBankModel.fromMap(cast(dbMap));
//      }
//    } catch (e) {
//      Logger().e(e);
//      throw CacheException();
//    }
//  }
//
//  @override
//  Future<Language> getLocalCurrentLanguage() {
//    try {
//      if (wordBankBox.isEmpty) {
//        throw CacheException();
//      } else {
//        final String dbLanguageIso = cast(
//          wordBankBox.get(cachedCurrentLanguageId),
//        );
//
//        return Future.value(Language.fromIsoCode(dbLanguageIso));
//      }
//    } catch (e) {
//      Logger().e(e);
//      throw CacheException();
//    }
//  }
//
//  @override
//  Future cacheCurrentDictionary(Language? language) async {
//    try {
//      if (language == null) {
//        await wordBankBox.delete(cachedCurrentLanguageId);
//      } else {
//        await wordBankBox.put(cachedCurrentLanguageId, language.isoCode);
//      }
//    } catch (e) {
//      Logger().e(e);
//      throw CacheException();
//    }
//  }
}
