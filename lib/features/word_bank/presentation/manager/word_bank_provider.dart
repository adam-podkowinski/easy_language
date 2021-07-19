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

  final GetWordBank getWordBankUseCase;
  final GetCurrentLanguage getCurrentLanguageUseCase;
  final EditWordList editWordListUseCase;
  final AddLanguageToWordBank addLanguageUseCase;

  Language? currentLanguage;
  WordBank wordBank = const WordBank(dictionaries: {});

  WordBankFailure? wordBankFailure;
  LanguageFailure? currentLanguageFailure;

  WordBankProvider({
    required this.getWordBankUseCase,
    required this.getCurrentLanguageUseCase,
    required this.editWordListUseCase,
    required this.addLanguageUseCase,
  });

  void _prepareMethod() {
    loading = true;
    wordBankFailure = null;
    currentLanguageFailure = null;
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

    currentLanguageEither.fold((l) {
      if (l is LanguageFailure) {
        currentLanguage = l.currentLanguage;
        currentLanguageFailure = l;
      }
    }, (r) => currentLanguage = r);

    loading = false;
    notifyListeners();
  }

  Future addLanguageToWordBank(Language language) async {
    _prepareMethod();

    final wordBankEither = await addLanguageUseCase(
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

    final currentLanguageEither = await getCurrentLanguageUseCase(NoParams());
    currentLanguageEither.fold((l) {
      if (l is LanguageFailure) {
        currentLanguage = l.currentLanguage;
        currentLanguageFailure = l;
      }
    }, (r) => currentLanguage = r);

    loading = false;
    notifyListeners();
  }
}
