part of 'word_bank_bloc.dart';

abstract class WordBankEvent extends Equatable {
  const WordBankEvent();
}

class GetWordBankEvent extends WordBankEvent {
  const GetWordBankEvent();

  @override
  List<Object?> get props => [];
}

class EditWordsListEvent extends WordBankEvent {
  const EditWordsListEvent({
    required this.languageFrom,
    this.languageTo,
    this.newWordList,
  });

  final Language languageFrom;
  final Language? languageTo;
  final List<Word>? newWordList;

  @override
  List<Object?> get props => [languageFrom, languageTo, newWordList];
}
