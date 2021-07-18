import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:hive/hive.dart';
import 'package:language_picker/languages.dart';

abstract class WordBankLocalDataSource {
  Future<WordBankModel> getLocalWordBank();

  Future<Language?> getLocalCurrentLanguage();

  Future<void> cacheWordBank(WordBankModel wordBankModel);

  Future<void> cacheCurrentLanguage(Language wordBankModel);
}

class WordBankLocalDataSourceImpl implements WordBankLocalDataSource {
  final Box wordBankBox;

  WordBankLocalDataSourceImpl({required this.wordBankBox});

  @override
  Future<void> cacheWordBank(WordBankModel wordBankModel) async {
    try {
      await wordBankBox.putAll(wordBankModel.toMap());
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<WordBankModel> getLocalWordBank() async {
    try {
      if (wordBankBox.isEmpty) {
        throw CacheException();
      } else {
        final dbMap = wordBankBox.toMap();
        return Future.value(WordBankModel.fromMap(dbMap));
      }
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<Language> getLocalCurrentLanguage() {
    try {
      if (wordBankBox.isEmpty) {
        throw CacheException();
      } else {
        final String dbLanguageIso = cast(
          wordBankBox.get(cachedCurrentLanguageId),
        );

        return Future.value(Language.fromIsoCode(dbLanguageIso));
      }
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future cacheCurrentLanguage(Language language) async {
    try {
      await wordBankBox.put(cachedCurrentLanguageId, language.isoCode);
    } catch (_) {
      throw CacheException();
    }
  }
}
