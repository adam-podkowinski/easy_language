import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/util/simplify_string.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:easy_language/features/word_bank/domain/repositories/dictionary_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:language_picker/languages.dart';

class DictionaryProvider extends ChangeNotifier {
  bool loading = true;

  final DictionaryRepository dictionaryRepository;

  Language? currentLanguage;
  Dictionaries dictionaries = {};
  Dictionary? get currentDictionary => dictionaries[currentLanguage];

  DictionariesFailure? dictionariesFailure;
  DictionaryFailure? currentDictionaryFailure;

  Word? currentFlashcard;
  FlashcardFailure? flashcardFailure;
  int? flashcardIndex;

  late final User user;

  DictionaryProvider({
    required this.dictionaryRepository,
  });

  List<Word>? searchedWords;

  String searchPhrase = '';

  void clearError() {
    currentDictionaryFailure = null;
    dictionariesFailure = null;
    flashcardFailure = null;
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
    notifyListeners();
  }

  void _finishMethod() {
    loading = false;
    notifyListeners();
  }

  List<Word>? searchWords(String? phraseToSearch) {
    var phrase = searchPhrase;

    if (phraseToSearch != null) {
      phrase = phraseToSearch;
      searchPhrase = phraseToSearch;
    }

    if (currentLanguage == null) {
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

  Future initDictionaryProvider(User loggedInUser) async {
    _prepareMethod();

    user = loggedInUser;

    final wordBankEither = await dictionaryRepository.initDictionaries(
      loggedInUser,
    );
    final currentDictionaryEither =
        await dictionaryRepository.initCurrentDictionary(user);

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
          currentDictionaryFailure = l;
        }
      },
      (r) => currentLanguage = r?.language,
    );

    _finishMethod();
  }

  Future addDictionary(Language lang) async {
    _prepareMethod();

    final wordBankEither = await dictionaryRepository.addDictionary(user, lang);

    wordBankEither.fold(
      (l) {
        if (l is DictionariesFailure) {
          dictionariesFailure = l;
          dictionaries = l.dictionaries;
        }
      },
      (r) => dictionaries = r,
    );

    currentLanguage = lang;

    _finishMethod();
  }

  Future removeLanguage(Language lang) async {
    _prepareMethod();

    final wordBankEither = await dictionaryRepository.removeDictionary(
      user,
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
        await dictionaryRepository.initCurrentDictionary(user);
    currentDictionaryEither.fold(
      (l) {
        if (l is DictionaryFailure) {
          currentDictionaryFailure = l;
        }
      },
      (r) => currentLanguage = r?.language,
    );

    _finishMethod();
  }

  Future addWord(
    BuildContext context,
    Map wordToAddMap,
  ) async {
    _prepareMethod();

    if (currentLanguage != null) {
      if (currentDictionary != null) {
        final wordBankEither = await dictionaryRepository.addWord(
          user,
          wordToAddMap,
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
          await dictionaryRepository.changeCurrentDictionary(
        user,
        language,
      );
      currentDictionaryEither.fold(
        (l) {
          if (l is DictionaryFailure) {
            currentLanguage = l.currentDictionary?.language;
            currentDictionaryFailure = l;
          }
        },
        (r) => currentLanguage = r.language,
      );
    }

    _finishMethod();
  }

  Future editWord(
    Word oldWord,
    Map changedMap, {
    bool? searching,
  }) async {
    _prepareMethod();

    final wordBankEither = await dictionaryRepository.editWord(
      user,
      oldWord.id,
      changedMap,
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

    final dictionariesEither = await dictionaryRepository.removeWord(
      user,
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

  void getCurrentFlashcard() {
    currentFlashcard = dictionaryRepository.getCurrentFlashcard(user);
    flashcardIndex = dictionaryRepository.getFlashcardIndex();
  }

  Future getNextFlashcard() async {
    _prepareMethod();
    currentFlashcard = await dictionaryRepository.getNextFlashcard(user);
    flashcardIndex = dictionaryRepository.getFlashcardIndex();
    _finishMethod();
  }

  Future turnCurrentFlashcard() async {
    _prepareMethod();

    final flashcardEither =
        await dictionaryRepository.turnCurrentFlashcard(user);

    flashcardEither.fold(
      (l) {
        if (l is FlashcardFailure) flashcardFailure = l;
      },
      (r) => currentFlashcard = r,
    );

    _finishMethod();
  }
}
