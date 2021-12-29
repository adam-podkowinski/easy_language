import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/word_bank/data/data_sources/dictionary_local_data_source.dart';
import 'package:easy_language/features/word_bank/data/data_sources/dictionary_remote_data_source.dart';
import 'package:easy_language/features/word_bank/data/models/dictionary_model.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:easy_language/features/word_bank/domain/repositories/dictionary_repository.dart';
import 'package:http/http.dart' as http;
import 'package:language_picker/languages.dart';
import 'package:logger/logger.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  DictionariesModel _dictionaries = {};
  Language? _currentLanguage;

  DictionaryModel? get _currentDictionary => _dictionaries[_currentLanguage];

  final DictionaryLocalDataSource localDataSource;
  final DictionaryRemoteDataSource remoteDataSource;

  DictionaryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  void logout() {
    _dictionaries.clear();
    _currentLanguage = null;
    localDataSource.logout();
  }

  @override
  Future<List<Word>> fetchCurrentDictionaryWords(User user) async {
    try {
      if (_currentDictionary == null) {
        throw 'currentDictionary is null';
      }

      final response = await http.get(
        Uri.parse('$api/dictionaries/${_currentDictionary!.id}/words'),
        headers: {
          'Authorization': 'Bearer ${user.token}',
          'Accept': 'application/json',
        },
      );

      if (!response.ok) {
        Logger().e(response.body);
        throw response;
      }

      final Map dictMap = cast(jsonDecode(response.body));

      final List wordListJSON = cast(dictMap['data']['words']);

      final List<Word> wordList =
          wordListJSON.map((e) => Word.fromMap(cast(e))).toList();

      _dictionaries[_currentLanguage!] = _currentDictionary!.copyWith(
        {},
        shouldFetch: false,
      );

      return wordList;
    } catch (e) {
      Logger().e(e);
      return [];
    }
  }

  @override
  Future<Either<Failure, Dictionaries>> addDictionary(
    User user,
    Language language,
  ) async {
    try {
      if (_dictionaries.containsKey(language)) {
        await changeCurrentDictionary(user, language);
      } else {
        _dictionaries[language] = await _addDictionaryRemote(user, language);
        await changeCurrentDictionary(user, language);
      }

      localDataSource.cacheDictionaries(_dictionaries);

      return Right(_dictionaries);
    } catch (_) {
      return Left(DictionariesCacheFailure(_dictionaries));
    }
  }

  @override
  Future<Either<Failure, Dictionaries>> removeDictionary(
    User user,
    Language language,
  ) async {
    try {
      final toRemove = _dictionaries[language];
      if (toRemove != null) {
        _dictionaries.removeWhere((key, value) => key == language);
        await http.delete(
          Uri.parse('$api/dictionaries/${toRemove.id}'),
          headers: {'Authorization': 'Bearer ${user.token}'},
        );
      }

      if (_dictionaries.isNotEmpty) {
        await changeCurrentDictionary(user, _dictionaries.keys.first);
      } else {
        _currentLanguage = null;
      }

      localDataSource.cacheDictionaries(_dictionaries);

      return Right(_dictionaries);
    } catch (e) {
      Logger().e(e);
      return Left(DictionariesCacheFailure(_dictionaries));
    }
  }

  @override
  Future<Either<Failure, Dictionary>> changeCurrentDictionary(
    User user,
    Language language,
  ) async {
    try {
      _currentLanguage = language;

      if (_currentDictionary!.shouldFetchWords) {
        final words = await fetchCurrentDictionaryWords(user);

        _dictionaries[_currentLanguage]?.words.clear();
        _dictionaries[_currentLanguage]?.words.addAll(words);

        localDataSource.cacheDictionaries(_dictionaries);
      }

      http.put(
        Uri.parse('$api/user'),
        headers: {'Authorization': 'Bearer ${user.token}'},
        body: {User.currentDictionaryIdId: _currentDictionary!.id.toString()},
      );
    } catch (e) {
      Logger().e(e);
      return Left(DictionaryCacheFailure(_currentDictionary));
    }
    return Right(_currentDictionary!);
  }

  @override
  Future<Either<Failure, Dictionary?>> initCurrentDictionary(User user) async {
    try {
      if (_dictionaries.isEmpty) {
        throw DictionaryGetFailure(null);
      }

      _currentLanguage = _dictionaries.values.firstWhere(
        (dict) => dict.id == user.currentDictionaryId,
        orElse: () {
          _currentLanguage = _dictionaries.values.first.language;
          http.put(
            Uri.parse('$api/user'),
            headers: {'Authorization': 'Bearer ${user.token}'},
            body: {
              User.currentDictionaryIdId: _currentDictionary!.id.toString()
            },
          );
          return _currentDictionary!;
        },
      ).language;

      if (_currentDictionary!.shouldFetchWords) {
        final words = await fetchCurrentDictionaryWords(user);

        _dictionaries[_currentLanguage]?.words.clear();
        _dictionaries[_currentLanguage]?.words.addAll(words);

        localDataSource.cacheDictionaries(_dictionaries);
      }
    } catch (_) {
      return Left(DictionaryGetFailure(_currentDictionary));
    }

    return Right(_currentDictionary);
  }

  @override
  Future<Either<Failure, Dictionaries>> initDictionaries(User user) async {
    try {
      final DictionariesModel cachedDictionaries =
          await localDataSource.getLocalDictionaries();

      _dictionaries = cachedDictionaries;

      final response = await http.get(
        Uri.parse('$api/dictionaries'),
        headers: {'Authorization': 'Bearer ${user.token}'},
      );

      if (!response.ok) {
        Logger().e(response.body);
      }

      final List remoteDicts = cast(jsonDecode(response.body));

      var shouldCache = false;

      if (remoteDicts.isNotEmpty) _dictionaries = {};

      for (final dict in remoteDicts) {
        final Language dictLang = Language.fromIsoCode(cast(dict[languageId]));
        final DateTime remoteUpdatedAt = DateTime.parse(
          cast(dict[updatedAtId]),
        );

        final DictionaryModel? localDict = cachedDictionaries[dictLang];

        final bool shouldFetch =
            localDict?.updatedAt.isBefore(remoteUpdatedAt) ?? true;

        final editMap = {
          'data': {
            'dictionary': dict,
          },
        };

        if (shouldFetch) {
          shouldCache = true;
          final dictionary = localDict == null
              ? DictionaryModel.fromMap(
                  editMap,
                  shouldFetch: shouldFetch,
                )
              : localDict.copyWith(editMap, shouldFetch: shouldFetch);
          _dictionaries[dictionary.language] = dictionary;
        } else {
          _dictionaries[localDict!.language] = localDict;
        }
      }

      if (shouldCache) {
        localDataSource.cacheDictionaries(_dictionaries);
      }
    } catch (e) {
      Logger().e(e);
      return Left(DictionariesGetFailure(_dictionaries));
    }

    return Right(_dictionaries);
  }

  @override
  Future<Either<Failure, Dictionaries>> addWord(User user, Map wordMap) async {
    try {
      if (_currentLanguage == null) {
        throw 'no current dictionary';
      }
      if (_dictionaries[_currentLanguage!] == null) {
        throw 'no dictionary';
      }

      final postMap = {
        ...wordMap,
        'language': _currentLanguage!.isoCode,
        'dictionary_id': _currentDictionary!.id.toString(),
      };

      final response = await http.post(
        Uri.parse('$api/words'),
        headers: {
          'Authorization': 'Bearer ${user.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(postMap),
      );

      if (!response.ok) {
        Logger().e(response.body);
        throw response;
      }

      final Map newWordMap = cast(jsonDecode(response.body));

      final newWord = Word.fromMap(newWordMap);

      _dictionaries[_currentLanguage!]!.words.insert(0, newWord);

      localDataSource.cacheDictionaries(_dictionaries);

      return Right(_dictionaries);
    } catch (e) {
      Logger().e(e);
      return Left(DictionariesCacheFailure(_dictionaries));
    }
  }

  @override
  Future<Either<Failure, Dictionaries>> editWord(
    User user,
    int id,
    Map editMap,
  ) async {
    try {
      if (_currentLanguage == null) {
        throw Error();
      }

      final response = await http.put(
        Uri.parse('$api/words/$id'),
        headers: {
          'Authorization': 'Bearer ${user.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(editMap),
      );

      if (!response.ok) {
        Logger().e(response.body);
        throw response;
      }

      final Map newWordMap = cast(jsonDecode(response.body));

      final Word newWord = Word.fromMap(newWordMap);

      final index = _currentDictionary!.words.indexWhere(
        (element) => element.id == newWord.id,
      );

      _currentDictionary!.words[index] = newWord;

      localDataSource.cacheDictionaries(_dictionaries);

      return Right(_dictionaries);
    } catch (e) {
      Logger().e(e);
      return Left(DictionariesFailure(_dictionaries));
    }
  }

  @override
  Future<Either<Failure, Dictionaries>> removeWord(
    User user,
    Word wordToRemove,
  ) async {
    try {
      if (_currentLanguage == null) {
        throw Error();
      }

      final idToRemove = wordToRemove.id;

      _currentDictionary!.words.remove(wordToRemove);

      final response = await http.delete(
        Uri.parse('$api/words/$idToRemove'),
        headers: {
          'Authorization': 'Bearer ${user.token}',
          'Accept': 'application/json',
        },
      );

      if (!response.ok) {
        Logger().e(response.body);
        throw response;
      }

      localDataSource.cacheDictionaries(_dictionaries);

      return Right(_dictionaries);
    } catch (e) {
      Logger().e(e);
      return Left(DictionariesFailure(_dictionaries));
    }
  }

  // Helpers
  Future<DictionaryModel> _addDictionaryRemote(
    User user,
    Language language,
  ) async {
    final response = await http.post(
      Uri.parse('$api/dictionaries'),
      body: {'language': language.isoCode},
      headers: {
        'Authorization': 'Bearer ${user.token}',
        'Accept': 'application/json',
      },
    );

    final Map dictJSON = cast(jsonDecode(response.body));

    return DictionaryModel.fromMap(dictJSON, shouldFetch: false);
  }
}
