import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/error/failures.dart';
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

  void _prepareMethod() {
    loading = true;
    wordBankFailure = null;
    currentLanguageFailure = null;
  }

  void _finishMethod() {
    loading = false;
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

  Future addLanguage(BuildContext context, Language? lang) async {
    _prepareMethod();

    if (lang == null) {
      _finishMethod();
      throw UnexpectedException();
    }

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

  Future changeWord(
    int index,
    Word newWord, {
    Language? language,
  }) async {
    _prepareMethod();

    final changeOnLang = language ?? currentLanguage;

    if (changeOnLang == null) {
      _finishMethod();
      throw UnexpectedException();
    }

    final newWordList = wordBank.dictionaries[changeOnLang];
    newWordList?[index] = newWord;
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

    _finishMethod();
  }

  Future removeWord(
    int index, {
    Language? language,
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

    newWordList.removeAt(index);
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
}
