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

  final WordBankRepository wordBankRepository;

  Language? currentLanguage;
  WordBank wordBank = const WordBank(dictionaries: {});

  WordBankFailure? wordBankFailure;
  LanguageFailure? currentLanguageFailure;

  WordBankProvider({
    required this.wordBankRepository,
  });

  List<Word>? searchedWords;

  String searchPhrase = '';

  int getLearningLength(Language language) {
    if (wordBank.dictionaries.containsKey(language)) {
      return wordBank.dictionaries[language]!
          .where(
            (element) => element.learningStatus == LearningStatus.learning,
          )
          .length;
    } else {
      return -1;
    }
  }

  int getReviewingLength(Language language) {
    if (wordBank.dictionaries.containsKey(language)) {
      return wordBank.dictionaries[language]!
          .where(
            (element) => element.learningStatus == LearningStatus.reviewing,
          )
          .length;
    } else {
      return -1;
    }
  }

  int getMasteredLength(Language language) {
    if (wordBank.dictionaries.containsKey(language)) {
      return wordBank.dictionaries[language]!
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
    currentLanguageFailure = null;
  }

  void _finishMethod() {
    loading = false;
    notifyListeners();
  }

  // TODO: move searchWords to a repository
  List<Word>? searchWords(String? phraseToSearch, {Language? language}) {
    var phrase = searchPhrase;

    if (phraseToSearch != null) {
      phrase = phraseToSearch;
      searchPhrase = phraseToSearch;
    }

    final Language? languageToSearch = language ?? currentLanguage;

    if (languageToSearch == null) {
      return null;
    }

    final wordsToSearchThrough = wordBank.dictionaries[languageToSearch];

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
    final currentLanguageEither = await wordBankRepository.getCurrentLanguage();

    wordBankEither.fold(
      (l) {
        if (l is WordBankFailure) {
          wordBank = l.wordBank;
          wordBankFailure = l;
        }
      },
      (r) => wordBank = r,
    );

    currentLanguageEither.fold(
      (l) {
        if (l is LanguageFailure) {
          currentLanguage = l.currentLanguage;
          currentLanguageFailure = l;
        }
      },
      (r) => currentLanguage = r,
    );

    _finishMethod();
  }

  Future addLanguage(Language lang) async {
    _prepareMethod();

    final wordBankEither = await wordBankRepository.addLanguageToWordBank(lang);

    wordBankEither.fold(
      (l) {
        if (l is WordBankFailure) {
          wordBankFailure = l;
          wordBank = l.wordBank;
        }
      },
      (r) => wordBank = r,
    );

    final currentLanguageEither = await wordBankRepository.getCurrentLanguage();
    currentLanguageEither.fold(
      (l) {
        if (l is LanguageFailure) {
          currentLanguage = l.currentLanguage;
          currentLanguageFailure = l;
        }
      },
      (r) => currentLanguage = r,
    );

    _finishMethod();
  }

  Future removeLanguage(Language lang) async {
    _prepareMethod();

    final wordBankEither = await wordBankRepository.removeLanguageFromWordBank(
      lang,
    );

    wordBankEither.fold(
      (l) {
        if (l is WordBankFailure) {
          wordBankFailure = l;
          wordBank = l.wordBank;
        }
      },
      (r) => wordBank = r,
    );

    final currentLanguageEither = await wordBankRepository.getCurrentLanguage();
    currentLanguageEither.fold(
      (l) {
        if (l is LanguageFailure) {
          currentLanguage = l.currentLanguage;
          currentLanguageFailure = l;
        }
      },
      (r) => currentLanguage = r,
    );

    _finishMethod();
  }

  Future addWordToCurrentLanguage(BuildContext context, Word wordToAdd) async {
    _prepareMethod();

    if (currentLanguage != null) {
      if (wordBank.dictionaries[currentLanguage] != null) {
        final wordBankEither = await wordBankRepository.editWordsList(
          languageFrom: currentLanguage!,
          newWordList: wordBank.dictionaries[currentLanguage]!
            ..insert(0, wordToAdd),
        );

        wordBankEither.fold(
          (l) {
            if (l is WordBankFailure) {
              wordBankFailure = l;
              wordBank = l.wordBank;
            }
          },
          (r) => wordBank = r,
        );
      }
    }

    _finishMethod();
  }

  Future changeCurrentLanguage(BuildContext context, Language? language) async {
    _prepareMethod();

    if (language == null) {
      _finishMethod();
      throw UnexpectedException();
    }

    if (wordBank.dictionaries[language] != null) {
      final currentLanguageEither =
          await wordBankRepository.changeCurrentLanguage(
        language,
      );
      currentLanguageEither.fold(
        (l) {
          if (l is LanguageFailure) {
            currentLanguage = l.currentLanguage;
            currentLanguageFailure = l;
          }
        },
        (r) => currentLanguage = r,
      );
    }

    _finishMethod();
  }

  Future editWord(
    Word oldWord,
    Word newWord, {
    Language? language,
    bool? searching,
  }) async {
    _prepareMethod();

    final changeOnLang = language ?? currentLanguage;

    if (changeOnLang == null) {
      _finishMethod();
      throw UnexpectedException();
    }

    final newWordList = wordBank.dictionaries[changeOnLang];
    if (newWordList == null) {
      return;
    }
    final index = newWordList.indexWhere((element) => element == oldWord);
    newWordList[index] = newWord;

    final wordBankEither = await wordBankRepository.editWordsList(
      languageFrom: changeOnLang,
      newWordList: newWordList,
    );

    wordBankEither.fold(
      (l) {
        if (l is WordBankFailure) {
          wordBankFailure = l;
          wordBank = l.wordBank;
        }
      },
      (r) => wordBank = r,
    );

    if (searching ?? false) {
      searchWords(null);
    }

    _finishMethod();
  }

  Future removeWord(
    Word wordToRemove, {
    Language? language,
    bool? searching,
  }) async {
    _prepareMethod();

    final changeOnLang = language ?? currentLanguage;

    if (changeOnLang == null) {
      _finishMethod();
      throw UnexpectedException();
    }

    final newWordList = wordBank.dictionaries[changeOnLang];

    if (newWordList == null) {
      _finishMethod();
      throw UnexpectedException();
    }

    newWordList.remove(wordToRemove);
    final wordBankEither = await wordBankRepository.editWordsList(
      languageFrom: changeOnLang,
      newWordList: newWordList,
    );

    wordBankEither.fold(
      (l) {
        if (l is WordBankFailure) {
          wordBankFailure = l;
          wordBank = l.wordBank;
        }
      },
      (r) => wordBank = r,
    );

    if (searching ?? false) {
      searchWords(null);
    }

    _finishMethod();
  }

  Future reorderWordList(
    List<Word> newWordList, {
    Language? language,
  }) async {
    _prepareMethod();

    final changeOnLang = language ?? currentLanguage;

    if (changeOnLang == null) {
      _finishMethod();
      throw UnexpectedException();
    }

    wordBank.dictionaries[changeOnLang] = newWordList;
    final wordList = wordBank.dictionaries[changeOnLang];

    if (wordList == null) {
      _finishMethod();
      throw UnexpectedException();
    }

    final wordBankEither = await wordBankRepository.editWordsList(
      languageFrom: changeOnLang,
      newWordList: wordList,
    );

    wordBankEither.fold(
      (l) {
        if (l is WordBankFailure) {
          wordBankFailure = l;
          wordBank = l.wordBank;
        }
      },
      (r) => wordBank = r,
    );

    _finishMethod();
  }

  Future fetchWordBankAndCurrentLanguage() async {
    _prepareMethod();

    final wordBankEither = await wordBankRepository.fetchWordBankRemotely();
    final currentLanguageEither =
        await wordBankRepository.fetchCurrentLanguageRemotely();

    wordBankEither.fold(
      (l) {
        if (l is WordBankFailure) {
          wordBank = l.wordBank;
          wordBankFailure = l;
        }
      },
      (r) => wordBank = r,
    );

    currentLanguageEither.fold(
      (l) {
        if (l is LanguageFailure) {
          currentLanguage = l.currentLanguage;
          currentLanguageFailure = l;
        }
      },
      (r) => currentLanguage = r,
    );

    _finishMethod();
  }

  Future saveWordBank() async {
    await wordBankRepository.saveWordBank();
  }

  Future saveCurrentLanguage() async {
    await wordBankRepository.saveCurrentLanguage();
  }
}
