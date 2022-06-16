import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_language/core/api/api_repository.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/dictionaries/data/data_sources/dictionary_local_data_source.dart';
import 'package:easy_language/features/dictionaries/data/models/dictionary_model.dart';
import 'package:easy_language/features/dictionaries/domain/entities/dictionary.dart';
import 'package:easy_language/features/dictionaries/domain/repositories/dictionaries_repository.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:easy_language/injection_container.dart';
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
  final ApiRepository dio;

  DictionariesRepositoryImpl({
    required this.localDataSource,
    required this.dio,
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

      final Response<Map> response = await dio().get(
        '$api/dictionaries/${currentDictionary!.id}/words',
      );

      if (!response.ok || response.data == null) {
        Logger().e(response.data);
        throw response;
      }

      final Map dictMap = response.data!;

      final List wordListJSON = cast(dictMap['words']);

      final List<Word> wordList = wordListJSON
          .map(
            (m) => Word.fromMap(cast(m)),
          )
          .toList();

      dictionaries[currentLanguage!] = currentDictionary!.copyWith(
        {},
        shouldFetch: false,
      );

      return wordList;
    } catch (e, stacktrace) {
      Logger().e(e);
      Logger().e(stacktrace);
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
      return InfoFailure(
        errorMessage:
            'Error: could not add a dictionary. Check your internet connection!',
      );
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
      final response = await dio().delete('$api/dictionaries/${toRemove.id}');

      if (!response.ok) throw response;

      if (dictionaries.isNotEmpty) {
        await changeCurrentDictionary(user, dictionaries.keys.first);
      } else {
        currentLanguage = null;
      }

      localDataSource.cacheDictionaries(dictionaries);

      return null;
    } catch (e, stacktrace) {
      Logger().e(e);
      Logger().e(stacktrace);
      return InfoFailure(
        errorMessage:
            'Error: could not remove a dictionary. Check your internet connection!',
      );
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

        currentDictionary?.words.clear();
        currentDictionary?.words.addAll(words);

        localDataSource.cacheDictionaries(dictionaries);
      }

      sl<UserRepository>().editUser(
        userMap: {
          User.currentDictionaryIdId: currentDictionary?.id,
        },
      );
    } catch (e) {
      Logger().e(e);
      return InfoFailure(
        errorMessage:
            'Error: could not change current dictionary. Check your internet connection!',
      );
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

          sl<UserRepository>().editUser(
            userMap: {
              User.currentDictionaryIdId: currentDictionary!.id,
            },
          );
          return currentDictionary!;
        },
      ).language;

      if (currentDictionary!.shouldFetchWords) {
        final words = await fetchCurrentDictionaryWords(user);

        currentDictionary?.words.clear();
        currentDictionary?.words.addAll(words);

        localDataSource.cacheDictionaries(dictionaries);
      }
    } catch (e) {
      Logger().e(e);
      return InfoFailure(
        errorMessage:
            'Error: could not init current dictionary. Check your internet connection!',
        showErrorMessage: false,
      );
    }

    return null;
  }

  @override
  Future<InfoFailure?> initDictionaries(User user) async {
    try {
      final DictionariesModel cachedDictionaries =
          await localDataSource.getLocalDictionaries();

      dictionaries = cachedDictionaries;

      final Response<List> response = await dio().get('$api/dictionaries');

      if (!response.ok || response.data == null) {
        Logger().e(response.data);
        throw response.data ?? 'No response data from $api/dictionaries';
      }

      final Iterable remoteDictsIterable = response.data!;
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
      return InfoFailure(
        errorMessage:
            'Error: could not init dictionaries. Check your internet connection!',
      );
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

      final Response<Map> response = await dio().post(
        '$api/words',
        data: postMap,
      );

      if (!response.ok || response.data == null) {
        Logger().e(response.data);
        throw response;
      }

      final Map newWordMap = response.data!;

      final newWord = Word.fromMap(newWordMap);

      dictionaries[currentLanguage!]!.words.insert(0, newWord);

      localDataSource.cacheDictionaries(dictionaries);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(
        errorMessage: 'Error: could not add a word. Check your internet connection!',
      );
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

      final Response<Map> response = await dio().patch(
        '$api/words/$id',
        data: editMap,
      );

      if (!response.ok || response.data == null) {
        Logger().e(response.data);
        throw response;
      }

      final Map newWordMap = response.data!;

      final Word newWord = Word.fromMap(newWordMap);

      final index = currentDictionary!.words.indexWhere(
        (element) => element.id == newWord.id,
      );

      currentDictionary!.words[index] = newWord;

      localDataSource.cacheDictionaries(dictionaries);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(
        errorMessage:
            'Error: could not edit word. Check your internet connection!',
      );
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

      final response = await dio().delete('$api/words/$idToRemove');

      if (!response.ok) {
        Logger().e(response.data);
        throw response;
      }

      localDataSource.cacheDictionaries(dictionaries);

      return null;
    } catch (e) {
      Logger().e(e);
      return InfoFailure(
        errorMessage:
            'Error: could not remove a word. Check your internet connection!',
      );
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

  Future _updateCurrentDictionaryRemotely(User user, Map body) async {
    final Response<String> res = await dio().patch(
      '$api/dictionaries/${currentDictionary!.id}',
      data: body,
    );
    if (!res.ok || res.data == null) Logger().e(res.data);
  }

  Future<DictionaryModel> _addDictionaryRemote(
    User user,
    Language language,
  ) async {
    final Response<Map> response = await dio().post(
      '$api/dictionaries',
      data: {'language': language.isoCode},
    );

    if (!response.ok || response.data == null) {
      Logger().e(response.data);
      throw response;
    }

    final Map dictJSON = response.data!;

    return DictionaryModel.fromMap(dictJSON, shouldFetch: false);
  }
}
