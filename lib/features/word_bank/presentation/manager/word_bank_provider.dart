import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/core/util/language_from_name.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/add_language_to_word_bank.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/change_current_language.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/edit_word_list.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_current_language.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_word_bank.dart';
import 'package:flutter/cupertino.dart';
import 'package:language_picker/languages.dart';

class WordBankProvider extends ChangeNotifier {
  bool loading = true;

  final GetWordBank getWordBankUseCase;
  final GetCurrentLanguage getCurrentLanguageUseCase;
  final EditWordList editWordListUseCase;
  final AddLanguageToWordBank addLanguageUseCase;
  final ChangeCurrentLanguage changeCurrentLanguageUseCase;

  Language? currentLanguage;
  WordBank wordBank = const WordBank(dictionaries: {});

  WordBankFailure? wordBankFailure;
  LanguageFailure? currentLanguageFailure;

  WordBankProvider({
    required this.getWordBankUseCase,
    required this.getCurrentLanguageUseCase,
    required this.editWordListUseCase,
    required this.addLanguageUseCase,
    required this.changeCurrentLanguageUseCase,
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

    final wordBankEither = await getWordBankUseCase(NoParams());
    final currentLanguageEither = await getCurrentLanguageUseCase(NoParams());

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

  Future addLanguage(Language? lang) async {
    _prepareMethod();

    if (lang == null) {
      _finishMethod();
      throw UnexpectedException();
    }

    final wordBankEither = await addLanguageUseCase(
      AddLanguageToWordBankParams(lang),
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

    final currentLanguageEither = await getCurrentLanguageUseCase(NoParams());
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

  Future addWordToCurrentLanguage(Word wordToAdd) async {
    _prepareMethod();

    if (currentLanguage != null) {
      if (wordBank.dictionaries[currentLanguage] != null) {
        final wordBankEither = await editWordListUseCase(
          EditWordListParams(
            languageFrom: currentLanguage!,
            newWordList: wordBank.dictionaries[currentLanguage]!
              ..insert(0, wordToAdd),
          ),
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

  Future changeCurrentLanguage(Language? language) async {
    _prepareMethod();

    if (language == null) {
      _finishMethod();
      throw UnexpectedException();
    }

    if (wordBank.dictionaries[language] != null) {
      final currentLanguageEither = await changeCurrentLanguageUseCase(
        ChangeCurrentLanguageParams(language: language),
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
}
