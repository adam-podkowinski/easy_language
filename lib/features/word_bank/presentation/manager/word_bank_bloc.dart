import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/use_cases/get_word_bank.dart';
import 'package:equatable/equatable.dart';

part 'word_bank_event.dart';

part 'word_bank_state.dart';

class WordBankBloc extends Bloc<WordBankEvent, WordBankState> {
  final GetWordBank getWordBank;

  WordBankBloc({required this.getWordBank}) : super(WordBankInitial());

  @override
  Stream<WordBankState> mapEventToState(
    WordBankEvent event,
  ) async* {
    if (event is GetWordBankEvent) {
      final wordBank = await getWordBank(NoParams());
      yield* wordBank.fold(
        (l) async* {
          if (l is WordBankFailure) {
            yield WordBankLoaded(wordBank: l.wordBank, failure: l);
          }
        },
        (r) async* {
          yield WordBankLoaded(wordBank: r);
        },
      );
    }
  }
}
