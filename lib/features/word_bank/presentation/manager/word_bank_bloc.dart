import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/edit_word_list.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_current_language.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_word_bank.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';

part 'word_bank_event.dart';

part 'word_bank_state.dart';

class WordBankBloc extends Bloc<WordBankEvent, WordBankState> {
  final GetWordBank getWordBank;
  final GetCurrentLanguage getCurrentLanguage;
  final EditWordList editWordList;

  Language? currentLanguage;
  WordBank wordBank = const WordBank(dictionaries: {});

  WordBankBloc({
    required this.getWordBank,
    required this.getCurrentLanguage,
    required this.editWordList,
  }) : super(WordBankInitial());

  @override
  Stream<WordBankState> mapEventToState(
    WordBankEvent event,
  ) async* {
    WordBankFailure? wordBankFailure;
    LanguageFailure? currentLanguageFailure;

    if (event is GetWordBankEvent) {
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

      yield WordBankLoaded(
        wordBank: wordBank,
        currentLanguage: currentLanguage,
        wordBankFailure: wordBankFailure,
        languageFailure: currentLanguageFailure,
      );
    } else if (event is EditWordsListEvent) {
      final wordBankEither = await editWordList(
        EditWordListParams(
          languageFrom: event.languageFrom,
          newWordList: event.newWordList,
          languageTo: event.languageTo,
        ),
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

      yield WordBankLoaded(
        wordBank: wordBank,
        currentLanguage: currentLanguage,
        wordBankFailure: wordBankFailure,
      );
    }
  }
}
