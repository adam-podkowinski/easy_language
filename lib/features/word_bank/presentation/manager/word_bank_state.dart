part of 'word_bank_bloc.dart';

abstract class WordBankState extends Equatable {
  const WordBankState();
}

class WordBankInitial extends WordBankState {
  @override
  List<Object> get props => [];
}

class WordBankLoaded extends WordBankState {
  final WordBank wordBank;
  final WordBankFailure? failure;

  const WordBankLoaded({required this.wordBank, this.failure});

  @override
  List<Object?> get props => [wordBank, failure];
}
