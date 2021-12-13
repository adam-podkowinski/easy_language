import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/data/data_sources/dictionary_local_data_source.dart';
import 'package:easy_language/features/word_bank/data/data_sources/dictionary_remote_data_source.dart';
import 'package:easy_language/features/word_bank/data/models/dictionary_model.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:easy_language/features/word_bank/domain/repositories/dictionary_repository.dart';
import 'package:http/http.dart' as http;
import 'package:language_picker/languages.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  bool _initialDictionaries = true;
  bool _initialCurrentLanguage = true;
  DictionariesModel _dictionaries = {};
  DictionaryModel? _currentDictionary;

  final DictionaryLocalDataSource localDataSource;
  final DictionaryRemoteDataSource remoteDataSource;

  DictionaryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<void> _ensureWordBankInitialized() async {
    if (_initialDictionaries) {
      await getDictionaries();
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

  Future<DictionaryModel> addDictionaryRemote(Language language) async {
    final response = await http.post(
      Uri.parse('$api/api/v1/dictionaries'),
      body: {'language': language.isoCode},
      headers: {
        'Authorization': 'Bearer fxdChHFr3whvY4LwHTZHQ8GFslhBP3OcZlqH8cdV',
        'Accept': 'application/json'
      },
    );

    final Map dictJSON = cast(jsonDecode(response.body));

    return DictionaryModel.fromMap(dictJSON);
  }

  @override
  Future<Either<Failure, Dictionaries>> addDictionary(Language language) async {
    try {
      await _ensureWordBankInitialized();

      if (_dictionaries.containsKey(language)) {
        await changeCurrentDictionary(language);
      } else {
        _dictionaries[language] = await addDictionaryRemote(language);
        await changeCurrentDictionary(language);
      }

      localDataSource.cacheDictionaries(_dictionaries);
      remoteDataSource.saveDictionaries(_dictionaries);

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
      remoteDataSource.saveDictionaries(_dictionaries);

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
  Future<Either<Failure, Dictionaries>> getDictionaries() async {
    try {
      if (_initialDictionaries) {
        _dictionaries = await localDataSource.getLocalWordBank();
        _initialDictionaries = false;
      }
    } catch (_) {
      _initialDictionaries = false;
      return Left(DictionariesGetFailure(_dictionaries));
    }

    return Right(_dictionaries);
  }

  @override
  Future<Either<Failure, Dictionaries>> fetchDictionariesRemotely() async {
    try {
      _dictionaries = await remoteDataSource.fetchDictionaries();
      localDataSource.cacheDictionaries(_dictionaries);
      _initialDictionaries = false;
      return Right(_dictionaries);
    } catch (_) {
      _initialDictionaries = false;
      _dictionaries = {};
      localDataSource.cacheDictionaries(_dictionaries);
      return Left(DictionariesGetFailure(_dictionaries));
    }
  }

  @override
  Future<Either<Failure, Dictionary?>> fetchCurrentDictionaryRemotely() async {
    try {
      _currentDictionary = await remoteDataSource.fetchCurrentDictionary();
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
      await remoteDataSource.saveDictionaries(_dictionaries);
    } catch (_) {
      return;
    }
  }

  @override
  Future<Either<Failure, Dictionaries>> addWord(Map wordMap) {
    // TODO: implement addWord
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Dictionaries>> editWord(
    int id,
    Map newWordMap,
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
