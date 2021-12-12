// iignore_for_file: prefer_const_constructors
// iignore_for_file: prefer_const_literals_to_create_immutables

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/data/data_sources/word_bank_local_data_source.dart';
import 'package:easy_language/features/word_bank/data/data_sources/word_bank_remote_data_source.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:language_picker/languages.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  bool _initialWordBank = true;
  bool _initialCurrentLanguage = true;
  DictionariesModel _dictionaries = {};
  DictionaryModel? _currentDictionary;

  final WordBankLocalDataSource localDataSource;
  final WordBankRemoteDataSource remoteDataSource;

  DictionaryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<void> _ensureWordBankInitialized() async {
    if (_initialWordBank) {
      await getWordBank();
    }
  }

  Future<void> _ensureCurrentLanguageInitialized() async {
    if (_initialCurrentLanguage) {
      await getCurrentDictionary();
    }
  }

  @override
  Future<List<Word>> fetchCurrentDictionaryWords() {
    return Future.value([]);
  }

  @override
  Future<Either<Failure, Dictionaries>> addDictionary(
    Language language, {
    List<Word>? initialWords,
  }) async {
    try {
      await _ensureWordBankInitialized();

      localDataSource.cacheDictionaries(_dictionaries);
      remoteDataSource.saveWordBank(_dictionaries);

      await changeCurrentDictionary(language);

      if (_dictionaries[language]?.words.isEmpty ?? false) {
        _dictionaries[language]!.words.addAll(initialWords ?? []);
      }

      return Right(_dictionaries);
    } catch (_) {
      return Left(DictionariesCacheFailure(_dictionaries));
    }
  }

  @override
  Future<Either<Failure, Dictionaries>> removeDictionary(
    Language language,
  ) async {
    try {
      await _ensureWordBankInitialized();
      if (_dictionaries[language] != null) {
        _dictionaries.removeWhere((key, value) => key == language);
      }

      localDataSource.cacheDictionaries(_dictionaries);
      remoteDataSource.saveWordBank(_dictionaries);

      if (_dictionaries.isNotEmpty) {
        await changeCurrentDictionary(_dictionaries.keys.first);
      } else {
        _currentDictionary = null;
      }

      return Right(_dictionaries);
    } catch (_) {
      return Left(DictionariesCacheFailure(_dictionaries));
    }
  }

  @override
  Future<Either<Failure, Dictionary>> changeCurrentDictionary(
    Language language,
  ) async {
    try {
      await _ensureCurrentLanguageInitialized();

      _currentDictionary = _dictionaries[language];

      if (_currentDictionary?.words == null) {
        _currentDictionary?.words.addAll(await fetchCurrentDictionaryWords());
      }

      localDataSource.cacheCurrentDictionary(_currentDictionary);
      remoteDataSource.saveCurrentDictionary(_currentDictionary!);
    } catch (_) {
      // we are sure current language is not null because we assign it previously
      // with a non-nullable function argument
      // and _ensureCurrentLanguageInitialized can't throw an error
      return Left(DictionaryCacheFailure(_currentDictionary));
    }
    return Right(_currentDictionary!);
  }

  /// Edit word list of a word bank
  /// You can change a language and a word list content
  //@override
  //Future<Either<Failure, Dictionaries>> editWordsList({
  //  required Language languageFrom,
  //  Language? languageTo,
  //  List<Word>? newWordList,
  //}) async {
  //  try {
  //    await _ensureWordBankInitialized();

  //    // Make sure a word list that we want to change exists
  //    if (_dictionaries.dictionaries[languageFrom] == null) {
  //      return Left(WordBankCacheFailure(_dictionaries));
  //    }

  //    // Change words list content
  //    if (newWordList != null) {
  //      _dictionaries.dictionaries[languageFrom] = newWordList;
  //    }

  //    // Change language of a word list
  //    if (languageTo != null) {
  //      // If new language place in dictionary is null we have to create it
  //      if (_dictionaries.dictionaries[languageTo] == null) {
  //        _dictionaries.dictionaries[languageTo] =
  //            _dictionaries.dictionaries[languageFrom]!;
  //      }

  //      // Otherwise we just append it (so old data from langaugeTo word list
  //      // will not be erased
  //      else {
  //        _dictionaries.dictionaries[languageTo]!.addAll(
  //          _dictionaries.dictionaries[languageFrom]!,
  //        );
  //      }
  //      _dictionaries.dictionaries[languageFrom]!.clear();
  //    }

  //    localDataSource.cacheWordBank(_dictionaries);
  //    remoteDataSource.saveWordBank(_dictionaries);
  //  } catch (_) {
  //    return Left(WordBankCacheFailure(_dictionaries));
  //  }

  //  return Right(_dictionaries);
  //}

  @override
  Future<Either<Failure, Dictionary?>> getCurrentDictionary() async {
    try {
      if (_initialCurrentLanguage) {
        final dbLang = await localDataSource.getLocalCurrentLanguage();
        _currentDictionary = _dictionaries[dbLang];
        _initialCurrentLanguage = false;
      }
    } catch (_) {
      _initialCurrentLanguage = false;
      return Left(DictionaryGetFailure(_currentDictionary));
    }

    return Right(_currentDictionary);
  }

  @override
  Future<Either<Failure, Dictionaries>> getWordBank() async {
    try {
      if (_initialWordBank) {
        _dictionaries = await localDataSource.getLocalWordBank();
        _initialWordBank = false;
      }
    } catch (_) {
      _initialWordBank = false;
      return Left(DictionariesGetFailure(_dictionaries));
    }

    return Right(_dictionaries);
  }

  @override
  Future<Either<Failure, Dictionaries>> fetchWordBankRemotely() async {
    try {
      _dictionaries = await remoteDataSource.fetchWordBank();
      localDataSource.cacheDictionaries(_dictionaries);
      _initialWordBank = false;
      return Right(_dictionaries);
    } catch (_) {
      _initialWordBank = false;
      _dictionaries = {};
      localDataSource.cacheDictionaries(_dictionaries);
      return Left(DictionariesGetFailure(_dictionaries));
    }
  }

  @override
  Future<Either<Failure, Dictionary?>> fetchCurrentDictionaryRemotely() async {
    try {
      _currentDictionary = await remoteDataSource.fetchCurrentLanguage();
      localDataSource.cacheCurrentDictionary(_currentDictionary);
      _initialCurrentLanguage = false;
      return Right(_currentDictionary);
    } catch (_) {
      _initialCurrentLanguage = false;
      _currentDictionary = null;
      localDataSource.cacheCurrentDictionary(_currentDictionary);
      return Left(DictionaryGetFailure(_currentDictionary));
    }
  }

  @override
  Future saveCurrentDictionary() async {
    try {
      if (_currentDictionary != null) {
        localDataSource.cacheCurrentDictionary(_currentDictionary);
        await remoteDataSource.saveCurrentDictionary(_currentDictionary!);
      }
    } catch (_) {
      return;
    }
  }

  @override
  Future saveDictionaries() async {
    try {
      localDataSource.cacheDictionaries(_dictionaries);
      await remoteDataSource.saveWordBank(_dictionaries);
    } catch (_) {
      return;
    }
  }

  @override
  Future<Either<Failure, Dictionaries>> addWord(Map<dynamic, dynamic> wordMap) {
    // TODO: implement addWord
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Dictionaries>> editWord(
    int id,
    Map<dynamic, dynamic> newWordMap,
  ) {
    // TODO: implement editWord
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Dictionaries>> removeWord(Word wordToRemove) {
    // TODO: implement removeWord
    throw UnimplementedError();
  }
}
