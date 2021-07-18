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
  final Language? currentLanguage;

  final WordBankFailure? wordBankFailure;
  final LanguageFailure? languageFailure;

  const WordBankLoaded({
    required this.wordBank,
    required this.currentLanguage,
    this.wordBankFailure,
    this.languageFailure,
  });

  @override
  List<Object?> get props => [
        wordBank,
        currentLanguage,
        wordBankFailure,
        languageFailure,
      ];
}
