import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/util/simplify_string.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:language_picker/languages.dart';

class WordBankProvider extends ChangeNotifier {
  bool loading = true;

  final DictionaryRepository wordBankRepository;

  Dictionary? currentDictionary;
  Dictionaries dictionaries = {};

  DictionariesFailure? wordBankFailure;
  DictionaryFailure? currentDictionaryFailure;

  WordBankProvider({
    required this.wordBankRepository,
  });

  List<Word>? searchedWords;

  String searchPhrase = '';

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
    wordBankFailure = null;
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

  Future initWordBank() async {
    _prepareMethod();

    final wordBankEither = await wordBankRepository.getWordBank();
    final currentDictionaryEither =
        await wordBankRepository.getCurrentDictionary();

    wordBankEither.fold(
      (l) {
        if (l is DictionariesFailure) {
          dictionaries = l.dictionaries;
          wordBankFailure = l;
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
          wordBankFailure = l;
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
          wordBankFailure = l;
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
    Map<String, dynamic> wordToAddMap,
  ) async {
    _prepareMethod();

    if (currentDictionary != null) {
      if (dictionaries[currentDictionary] != null) {
        final wordBankEither = await wordBankRepository.addWord(wordToAddMap);

        wordBankEither.fold(
          (l) {
            if (l is DictionariesFailure) {
              wordBankFailure = l;
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
      BuildContext context, Language? language) async {
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
    Map<String, dynamic> newWordMap, {
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
          wordBankFailure = l;
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
        if (l is Dictionaries) {
          wordBankFailure = l;
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

  //Future reorderWordList(
  //  List<Word> newWordList, {
  //  Language? language,
  //}) async {
  //  _prepareMethod();

  //  final changeOnLang = language ?? currentDictionary;

  //  if (changeOnLang == null) {
  //    _finishMethod();
  //    throw UnexpectedException();
  //  }

  //  dictionaries.dictionaries[changeOnLang] = newWordList;
  //  final wordList = dictionaries.dictionaries[changeOnLang];

  //  if (wordList == null) {
  //    _finishMethod();
  //    throw UnexpectedException();
  //  }

  //  final wordBankEither = await wordBankRepository.editWordsList(
  //    languageFrom: changeOnLang,
  //    newWordList: wordList,
  //  );

  //  wordBankEither.fold(
  //    (l) {
  //      if (l is WordBankFailure) {
  //        wordBankFailure = l;
  //        dictionaries = l.wordBank;
  //      }
  //    },
  //    (r) => dictionaries = r,
  //  );

  //  _finishMethod();
  //}

  Future fetchDictionaries() async {
    _prepareMethod();

    final wordBankEither = await wordBankRepository.fetchWordBankRemotely();
    final currentDictionaryEither =
        await wordBankRepository.fetchCurrentDictionaryRemotely();

    wordBankEither.fold(
      (l) {
        if (l is Dictionaries) {
          dictionaries = l.dictionaries;
          wordBankFailure = l;
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
    await wordBankRepository.saveWordBank();
  }

  Future savecurrentDictionary() async {
    await wordBankRepository.savecurrentDictionary();
  }
}
