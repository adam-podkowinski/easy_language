import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/add_language_to_word_bank.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/edit_word_list.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_current_language.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_word_bank.dart';
import 'package:flutter/cupertino.dart';
import 'package:language_picker/languages.dart';

class WordBankProvider extends ChangeNotifier {
  bool loading = true;

  final GetWordBank getWordBank;
  final GetCurrentLanguage getCurrentLanguage;
  final EditWordList editWordList;
  final AddLanguageToWordBank addLanguage;

  Language? currentLanguage;
  WordBank wordBank = const WordBank(dictionaries: {});

  WordBankFailure? wordBankFailure;
  LanguageFailure? currentLanguageFailure;

  WordBankProvider({
    required this.getWordBank,
    required this.getCurrentLanguage,
    required this.editWordList,
    required this.addLanguage,
  });

  void _prepareMethod() {
    loading = true;
    wordBankFailure = null;
    currentLanguageFailure = null;
  }

  Future<WordBank> initWordBank() async {
    _prepareMethod();

    final wordBankEither = await getWordBank(NoParams());
    final currentLanguageEither = await getCurrentLanguage(NoParams());

    wordBankEither.fold(
      (l) {
        if (l is WordBankFailure) {
          wordBank = l.wordBank;
          wordBankFailure = l;
        }
      },
      (r) => wordBank = r,
    );

    currentLanguageEither.fold((l) {
      if (l is LanguageFailure) {
        currentLanguage = l.currentLanguage;
        currentLanguageFailure = l;
      }
    }, (r) => currentLanguage = r);

    loading = false;
    notifyListeners();
    return wordBank;
  }

  Future<WordBank> addLanguageToWordBank(Language language) async {
    _prepareMethod();

    final wordBankEither = await addLanguage(
      AddLanguageToWordBankParams(language),
    );

    wordBankEither.fold(
      (l) {
        if (l is WordBankFailure) {
          wordBankFailure = l;
          wordBank = l.wordBank;
        }
      },
      (r) {
        wordBank = r;
      },
    );

    final currentLanguageEither = await getCurrentLanguage(NoParams());
    currentLanguageEither.fold((l) {
      if (l is LanguageFailure) {
        currentLanguage = l.currentLanguage;
        currentLanguageFailure = l;
      }
    }, (r) => currentLanguage = r);

    loading = false;
    notifyListeners();
    return wordBank;
  }
}
