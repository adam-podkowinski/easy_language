part of 'word_bank_bloc.dart';

abstract class WordBankEvent extends Equatable {
  const WordBankEvent();
}

class GetWordBankEvent extends WordBankEvent {
  const GetWordBankEvent();

  @override
  List<Object?> get props => [];
}
