import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/util/simplify_string.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:easy_language/features/word_bank/domain/repositories/dictionary_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:language_picker/languages.dart';

class DictionaryProvider extends ChangeNotifier {
  bool loading = true;

  final DictionaryRepository wordBankRepository;

  Dictionary? currentDictionary;
  Dictionaries dictionaries = {};

  DictionariesFailure? dictionariesFailure;
  DictionaryFailure? currentDictionaryFailure;

  DictionaryProvider({
    required this.wordBankRepository,
  });

  List<Word>? searchedWords;

  String searchPhrase = '';

  void clearError() {
    currentDictionaryFailure = null;
    dictionariesFailure = null;
  }

  int getLearningLength(Language language) {
    if (dictionaries.containsKey(language)) {
      return dictionaries[language]!
          .words
          .where(
            (element) => element.learningStatus == LearningStatus.learning,
          )
          .length;
    } else {
      return -1;
    }
  }

  int getReviewingLength(Language language) {
    if (dictionaries.containsKey(language)) {
      return dictionaries[language]!
          .words
          .where(
            (element) => element.learningStatus == LearningStatus.reviewing,
          )
          .length;
    } else {
      return -1;
    }
  }

  int getMasteredLength(Language language) {
    if (dictionaries.containsKey(language)) {
      return dictionaries[language]!
          .words
          .where(
            (element) => element.learningStatus == LearningStatus.mastered,
          )
          .length;
    } else {
      return -1;
    }
  }

  void _prepareMethod() {
    loading = true;
    dictionariesFailure = null;
    currentDictionaryFailure = null;
  }

  void _finishMethod() {
    loading = false;
    notifyListeners();
  }

  // TODO: move searchWords to a repository
  List<Word>? searchWords(String? phraseToSearch) {
    var phrase = searchPhrase;

    if (phraseToSearch != null) {
      phrase = phraseToSearch;
      searchPhrase = phraseToSearch;
    }

    if (currentDictionary == null) {
      return null;
    }

    final wordsToSearchThrough = currentDictionary?.words;

    if (wordsToSearchThrough == null) {
      return null;
    }

    searchedWords = wordsToSearchThrough
        .where(
          (e) =>
              simplifyString(e.wordForeign).contains(
                simplifyString(phrase),
              ) ||
              simplifyString(e.wordTranslation).contains(
                simplifyString(phrase),
              ),
        )
        .toList();

    notifyListeners();
  }

  Future initDictionaryProvider() async {
    _prepareMethod();

    final wordBankEither = await wordBankRepository.getDictionaries();
    final currentDictionaryEither =
        await wordBankRepository.getCurrentDictionary();

    wordBankEither.fold(
      (l) {
        if (l is DictionariesFailure) {
          dictionaries = l.dictionaries;
          dictionariesFailure = l;
        }
      },
      (r) => dictionaries = r,
    );

    currentDictionaryEither.fold(
      (l) {
        if (l is DictionaryFailure) {
          currentDictionary = l.currentDictionary;
          currentDictionaryFailure = l;
        }
      },
      (r) => currentDictionary = r,
    );

    _finishMethod();
  }

  Future addLanguage(Language lang) async {
    _prepareMethod();

    final wordBankEither = await wordBankRepository.addDictionary(lang);

    wordBankEither.fold(
      (l) {
        if (l is DictionariesFailure) {
          dictionariesFailure = l;
          dictionaries = l.dictionaries;
        }
      },
      (r) => dictionaries = r,
    );

    final currentDictionaryEither =
        await wordBankRepository.getCurrentDictionary();
    currentDictionaryEither.fold(
      (l) {
        if (l is DictionaryFailure) {
          currentDictionary = l.currentDictionary;
          currentDictionaryFailure = l;
        }
      },
      (r) => currentDictionary = r,
    );

    _finishMethod();
  }

  Future removeLanguage(Language lang) async {
    _prepareMethod();

    final wordBankEither = await wordBankRepository.removeDictionary(
      lang,
    );

    wordBankEither.fold(
      (l) {
        if (l is DictionariesFailure) {
          dictionariesFailure = l;
          dictionaries = l.dictionaries;
        }
      },
      (r) => dictionaries = r,
    );

    final currentDictionaryEither =
        await wordBankRepository.getCurrentDictionary();
    currentDictionaryEither.fold(
      (l) {
        if (l is DictionaryFailure) {
          currentDictionary = l.currentDictionary;
          currentDictionaryFailure = l;
        }
      },
      (r) => currentDictionary = r,
    );

    _finishMethod();
  }

  Future addWord(
    BuildContext context,
    Map wordToAddMap,
  ) async {
    _prepareMethod();

    if (currentDictionary != null) {
      if (dictionaries[currentDictionary] != null) {
        final wordBankEither = await wordBankRepository.addWord(wordToAddMap);

        wordBankEither.fold(
          (l) {
            if (l is DictionariesFailure) {
              dictionariesFailure = l;
              dictionaries = l.dictionaries;
            }
          },
          (r) => dictionaries = r,
        );
      }
    }

    _finishMethod();
  }

  Future changeCurrentDictionary(
    BuildContext context,
    Language? language,
  ) async {
    _prepareMethod();

    if (language == null) {
      _finishMethod();
      throw UnexpectedException();
    }

    if (dictionaries[language] != null) {
      final currentDictionaryEither =
          await wordBankRepository.changeCurrentDictionary(
        language,
      );
      currentDictionaryEither.fold(
        (l) {
          if (l is DictionaryFailure) {
            currentDictionary = l.currentDictionary;
            currentDictionaryFailure = l;
          }
        },
        (r) => currentDictionary = r,
      );
    }

    _finishMethod();
  }

  Future editWord(
    Word oldWord,
    Map newWordMap, {
    bool? searching,
  }) async {
    _prepareMethod();

    final wordBankEither = await wordBankRepository.editWord(
      oldWord.id,
      newWordMap,
    );

    wordBankEither.fold(
      (l) {
        if (l is DictionariesFailure) {
          dictionariesFailure = l;
          dictionaries = l.dictionaries;
        }
      },
      (r) => dictionaries = r,
    );

    if (searching ?? false) {
      searchWords(null);
    }

    _finishMethod();
  }

  Future removeWord(
    Word wordToRemove, {
    bool? searching,
  }) async {
    _prepareMethod();

    final dictionariesEither = await wordBankRepository.removeWord(
      wordToRemove,
    );

    dictionariesEither.fold(
      (l) {
        if (l is DictionariesFailure) {
          dictionariesFailure = l;
          dictionaries = l.dictionaries;
        }
      },
      (r) => dictionaries = r,
    );

    if (searching ?? false) {
      searchWords(null);
    }

    _finishMethod();
  }

  Future fetchDictionaries() async {
    _prepareMethod();

    final wordBankEither = await wordBankRepository.fetchDictionariesRemotely();
    final currentDictionaryEither =
        await wordBankRepository.fetchCurrentDictionaryRemotely();

    wordBankEither.fold(
      (l) {
        if (l is DictionariesFailure) {
          dictionaries = l.dictionaries;
          dictionariesFailure = l;
        }
      },
      (r) => dictionaries = r,
    );

    currentDictionaryEither.fold(
      (l) {
        if (l is DictionaryFailure) {
          currentDictionary = l.currentDictionary;
          currentDictionaryFailure = l;
        }
      },
      (r) => currentDictionary = r,
    );

    _finishMethod();
  }

  Future saveWordBank() async {
    await wordBankRepository.saveDictionaries();
  }

  Future saveCurrentDictionary() async {
    await wordBankRepository.saveCurrentDictionary();
  }
}
