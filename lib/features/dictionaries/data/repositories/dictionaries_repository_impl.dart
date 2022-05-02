import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/dictionaries/data/data_sources/dictionary_local_data_source.dart';
import 'package:easy_language/features/dictionaries/data/data_sources/dictionary_remote_data_source.dart';
import 'package:easy_language/features/dictionaries/data/models/dictionary_model.dart';
import 'package:easy_language/features/dictionaries/domain/entities/dictionary.dart';
import 'package:easy_language/features/dictionaries/domain/repositories/dictionaries_repository.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'package:language_picker/languages.dart';
import 'package:logger/logger.dart';

class DictionariesRepositoryImpl implements DictionariesRepository {
  @override
  DictionariesModel dictionaries = {};
  @override
  Language? currentLanguage;
  @override
  DictionaryModel? get currentDictionary => dictionaries[currentLanguage];

  final DictionariesLocalDataSource localDataSource;
  final DictionariesRemoteDataSource remoteDataSource;

  DictionariesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  void logout() {
    dictionaries.clear();
    currentLanguage = null;
    localDataSource.logout();
  }

  @override
  Future<List<Word>> fetchCurrentDictionaryWords(User user) async {
    try {
      if (currentDictionary == null) {
        throw 'currentDictionary is null';
      }

      final response = await http.get(
        Uri.parse('$api/dictionaries/${currentDictionary!.id}/words'),
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

      final List wordListJSON = cast(dictMap['words']);

      final List<Word> wordList =
          wordListJSON.map((e) => Word.fromMap(cast(e))).toList();

      dictionaries[currentLanguage!] = currentDictionary!.copyWith(
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
  Future<InfoFailure?> addDictionary(
    User user,
    Language language,
  ) async {
    try {
      if (dictionaries.containsKey(language)) {
        await changeCurrentDictionary(user, language);
      } else {
        dictionaries[language] = await _addDictionaryRemote(user, language);
        await changeCurrentDictionary(user, language);
      }

      localDataSource.cacheDictionaries(dictionaries);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: e.toString());
    }
  }

  @override
  Future<InfoFailure?> removeDictionary(
    User user,
    Language language,
  ) async {
    try {
      final toRemove = dictionaries[language];
      if (toRemove == null) {
        throw InfoFailure(errorMessage: 'No word to remove.');
      }

      dictionaries.removeWhere((key, value) => key == language);
      // TODO: Get new current dictionary from http delete response
      await http.delete(
        Uri.parse('$api/dictionaries/${toRemove.id}'),
        headers: {'Authorization': 'Bearer ${user.token}'},
      );

      if (dictionaries.isNotEmpty) {
        await changeCurrentDictionary(user, dictionaries.keys.first);
      } else {
        currentLanguage = null;
      }

      localDataSource.cacheDictionaries(dictionaries);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: e.toString());
    }
  }

  @override
  Future<InfoFailure?> changeCurrentDictionary(
    User user,
    Language language,
  ) async {
    try {
      currentLanguage = language;

      if (currentDictionary!.shouldFetchWords) {
        final words = await fetchCurrentDictionaryWords(user);

        dictionaries[currentLanguage]?.words.clear();
        dictionaries[currentLanguage]?.words.addAll(words);

        localDataSource.cacheDictionaries(dictionaries);
      }

      http.patch(
        Uri.parse('$api/user'),
        headers: {'Authorization': 'Bearer ${user.token}'},
        body: {User.currentDictionaryIdId: currentDictionary!.id.toString()},
      );
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: e.toString());
    }
    return null;
  }

  @override
  Future<InfoFailure?> initCurrentDictionary(User user) async {
    try {
      if (dictionaries.isEmpty) {
        throw InfoFailure(errorMessage: 'Dictionaries is empty');
      }

      currentLanguage = dictionaries.values.firstWhere(
        (dict) => dict.id == user.currentDictionaryId,
        orElse: () {
          currentLanguage = dictionaries.values.first.language;
          http.patch(
            Uri.parse('$api/user'),
            headers: {'Authorization': 'Bearer ${user.token}'},
            body: {
              User.currentDictionaryIdId: currentDictionary!.id.toString()
            },
          );
          return currentDictionary!;
        },
      ).language;

      if (currentDictionary!.shouldFetchWords) {
        final words = await fetchCurrentDictionaryWords(user);

        dictionaries[currentLanguage]?.words.clear();
        dictionaries[currentLanguage]?.words.addAll(words);

        localDataSource.cacheDictionaries(dictionaries);
      }
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: e.toString(), showErrorMessage: false);
    }

    return null;
  }

  @override
  Future<InfoFailure?> initDictionaries(User user) async {
    try {
      final DictionariesModel cachedDictionaries =
          await localDataSource.getLocalDictionaries();

      dictionaries = cachedDictionaries;

      final response = await http.get(
        Uri.parse('$api/dictionaries'),
        headers: {'Authorization': 'Bearer ${user.token}'},
      );

      if (!response.ok) {
        Logger().e(response.body);
      }

      final Iterable remoteDictsIterable = cast(jsonDecode(response.body));
      final List<Map> remoteDicts = List<Map>.from(remoteDictsIterable);

      var shouldCache = false;

      if (remoteDicts.isNotEmpty) dictionaries = {};

      for (final dict in remoteDicts) {
        final Language dictLang = Language.fromIsoCode(cast(dict[languageId]));
        final DateTime remoteUpdatedAt = DateTime.parse(
          cast(dict[updatedAtId]),
        );

        final DictionaryModel? localDict = cachedDictionaries[dictLang];

        final bool shouldFetch =
            localDict?.updatedAt.isBefore(remoteUpdatedAt) ?? true;

        if (shouldFetch) {
          shouldCache = true;
          final dictionary = localDict == null
              ? DictionaryModel.fromMap(
                  dict,
                  shouldFetch: shouldFetch,
                )
              : localDict.copyWith(dict, shouldFetch: shouldFetch);
          dictionaries[dictionary.language] = dictionary;
        } else {
          dictionaries[localDict!.language] = localDict;
        }
      }

      if (shouldCache) {
        localDataSource.cacheDictionaries(dictionaries);
      }
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: e.toString());
    }

    return null;
  }

  @override
  Future<InfoFailure?> addWord(User user, Map wordMap) async {
    try {
      if (currentLanguage == null) {
        throw 'no current dictionary';
      }
      if (dictionaries[currentLanguage!] == null) {
        throw 'no dictionary';
      }

      final postMap = {
        ...wordMap,
        Word.dictionaryIdId: currentDictionary!.id.toString(),
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

      dictionaries[currentLanguage!]!.words.insert(0, newWord);

      localDataSource.cacheDictionaries(dictionaries);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: e.toString());
    }
  }

  @override
  Future<InfoFailure?> editWord(
    User user,
    int id,
    Map editMap,
  ) async {
    try {
      if (currentLanguage == null) {
        throw Error();
      }

      final response = await http.patch(
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

      final index = currentDictionary!.words.indexWhere(
        (element) => element.id == newWord.id,
      );

      currentDictionary!.words[index] = newWord;

      localDataSource.cacheDictionaries(dictionaries);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: e.toString());
    }
  }

  @override
  Future<InfoFailure?> removeWord(
    User user,
    Word wordToRemove,
  ) async {
    try {
      if (currentLanguage == null) {
        throw Error();
      }

      final idToRemove = wordToRemove.id;

      currentDictionary!.words.remove(wordToRemove);

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

      localDataSource.cacheDictionaries(dictionaries);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(errorMessage: e.toString());
    }
  }

  @override
  int? getFlashcardIndex() {
    return currentDictionary?.words.indexWhere(
      (w) => w.id == currentDictionary!.flashcardId,
    );
  }

  @override
  Word? getCurrentFlashcard(User user) {
    if (currentDictionary == null ||
        (currentDictionary?.words.isEmpty ?? true)) {
      return null;
    }

    final Word word = currentDictionary!.words.firstWhere(
      (w) => w.id == currentDictionary!.flashcardId,
      orElse: () {
        final flashcard = currentDictionary!.words.first;
        dictionaries[currentLanguage!] = currentDictionary!.copyWith({
          Dictionary.flashcardIdId: flashcard.id,
        });

        // Save current flashcard id.
        _updateCurrentDictionaryRemotely(
          user,
          {Dictionary.flashcardIdId: flashcard.id},
        );

        return flashcard;
      },
    );

    return word;
  }

  @override
  Word? getNextFlashcard(User user) {
    if (currentDictionary == null ||
        (currentDictionary?.words.isEmpty ?? true)) {
      return null;
    }

    int currentFlashcardIndex = currentDictionary!.words.indexWhere(
      (w) => w.id == currentDictionary?.flashcardId,
    );

    if (currentFlashcardIndex < 0) {
      return null;
    }

    if (currentFlashcardIndex >= currentDictionary!.words.length - 1) {
      currentFlashcardIndex = 0;
    } else {
      currentFlashcardIndex++;
    }

    final Word flashcard = currentDictionary!.words[currentFlashcardIndex];

    dictionaries[currentDictionary!.language] = currentDictionary!.copyWith({
      Dictionary.flashcardIdId: flashcard.id,
    });

    localDataSource.cacheDictionaries(dictionaries);

    // Save current flashcard id.
    _updateCurrentDictionaryRemotely(
      user,
      {Dictionary.flashcardIdId: flashcard.id},
    );

    return flashcard;
  }

  // TODO: Move helper methods to the remote data source.
  Future<String> _updateCurrentDictionaryRemotely(User user, Map body) async {
    final res = await http.patch(
      Uri.parse('$api/dictionaries/${currentDictionary!.id}'),
      headers: {
        'Authorization': 'Bearer ${user.token}',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(body),
    );
    if (!res.ok) Logger().e(res.body);

    return res.body;
  }

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
