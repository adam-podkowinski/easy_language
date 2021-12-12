import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:hive/hive.dart';
import 'package:language_picker/languages.dart';
import 'package:logger/logger.dart';

abstract class WordBankLocalDataSource {
  Future<DictionariesModel> getLocalWordBank();

  Future<Language> getLocalCurrentLanguage();

  Future<void> cacheDictionaries(DictionariesModel wordBankModel);

  Future<void> cacheCurrentDictionary(DictionaryModel? wordBankModel);
}

class WordBankLocalDataSourceImpl implements WordBankLocalDataSource {
  @override
  Future<void> cacheCurrentDictionary(DictionaryModel? wordBankModel) {
    // TODO: implement cacheCurrentDictionary
    throw UnimplementedError();
  }

  @override
  Future<void> cacheDictionaries(DictionariesModel wordBankModel) {
    // TODO: implement cacheDictionaries
    throw UnimplementedError();
  }

  @override
  Future<Language> getLocalCurrentLanguage() {
    // TODO: implement getLocalCurrentLanguage
    throw UnimplementedError();
  }

  @override
  Future<DictionariesModel> getLocalWordBank() {
    // TODO: implement getLocalWordBank
    throw UnimplementedError();
  }
 final Box wordBankBox;

 WordBankLocalDataSourceImpl({required this.wordBankBox});
//
//  @override
//  Future<void> cacheDictionaries(WordBankModel wordBankModel) async {
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
