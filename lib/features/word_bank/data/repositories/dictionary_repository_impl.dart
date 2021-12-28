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

// TODO: cache dictionaries
class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionariesModel _dictionaries = {};
  DictionaryModel? _currentDictionary;

  final DictionaryLocalDataSource localDataSource;
  final DictionaryRemoteDataSource remoteDataSource;

  DictionaryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  void logout() {
    _dictionaries.clear();
    _currentDictionary = null;
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

      // TODO: set shouldFetchWords of a currentDictionary to false

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
        _currentDictionary = null;
      }

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
      _currentDictionary = _dictionaries[language];

      // TODO: only fetch words when shouldFetchWords field is true
      if (_currentDictionary!.words.isEmpty) {
        final words = await fetchCurrentDictionaryWords(user);

        if (words.isNotEmpty) {
          _currentDictionary?.words.clear();
          _currentDictionary?.words.addAll(words);
        }
      }

      await http.put(
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
  Future<Either<Failure, Dictionary?>> getCurrentDictionary(User user) async {
    try {
      if (_dictionaries.isEmpty) {
        throw DictionaryGetFailure(null);
      }
      _currentDictionary = _dictionaries.values.firstWhere(
        (dict) => dict.id == user.currentDictionaryId,
        orElse: () {
          _currentDictionary = _dictionaries.values.first;
          http.put(
            Uri.parse('$api/user'),
            headers: {'Authorization': 'Bearer ${user.token}'},
            body: {
              User.currentDictionaryIdId: _currentDictionary!.id.toString()
            },
          );
          return _currentDictionary!;
        },
      );

      await changeCurrentDictionary(user, _currentDictionary!.language);
    } catch (_) {
      return Left(DictionaryGetFailure(_currentDictionary));
    }

    return Right(_currentDictionary);
  }

  @override
  Future<Either<Failure, Dictionaries>> getDictionaries(User user) async {
    try {
      final response = await http.get(
        Uri.parse('$api/dictionaries'),
        headers: {'Authorization': 'Bearer ${user.token}'},
      );

      if (!response.ok) {
        return Left(DictionariesGetFailure(_dictionaries));
      }

      final List dicts = cast(jsonDecode(response.body));

      for (final dict in dicts) {
        // TODO: set shouldFetchWords field according to updated_at vs updated_at from cached dictionary
        final dictionary = DictionaryModel.fromMap({
          'data': {'dictionary': dict}
        });

        _dictionaries[dictionary.language] = dictionary;
      }

      localDataSource.cacheDictionaries(_dictionaries);
    } catch (_) {
      return Left(DictionariesGetFailure(_dictionaries));
    }

    return Right(_dictionaries);
  }

  @override
  Future<Either<Failure, Dictionaries>> addWord(User user, Map wordMap) async {
    try {
      if (_currentDictionary == null) {
        throw 'no current dictionary';
      }
      if (_dictionaries[_currentDictionary!.language] == null) {
        throw 'no dictionary';
      }

      final postMap = {
        ...wordMap,
        'language': _currentDictionary!.language.isoCode,
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

      _dictionaries[_currentDictionary!.language]!.words.insert(0, newWord);

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
      if (_currentDictionary == null) {
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
      if (_currentDictionary == null) {
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

    return DictionaryModel.fromMap(dictJSON);
  }
}
