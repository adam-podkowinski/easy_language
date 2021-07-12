import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_current_language.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_word_bank.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

part 'word_bank_event.dart';

part 'word_bank_state.dart';

class WordBankBloc extends Bloc<WordBankEvent, WordBankState> {
  final GetWordBank getWordBank;
  final GetCurrentLanguage getCurrentLanguage;

  WordBankBloc({required this.getWordBank, required this.getCurrentLanguage})
      : super(WordBankInitial());

  @override
  Stream<WordBankState> mapEventToState(
    WordBankEvent event,
  ) async* {
    if (event is GetWordBankEvent) {
      final wordBankEither = await getWordBank(NoParams());
      final currentLanguageEither = await getCurrentLanguage(NoParams());

      late final WordBank wordBank;
      WordBankFailure? wordBankFailure;
      Language? currentLanguage;
      LanguageFailure? currentLanguageFailure;

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
    }
  }
}
