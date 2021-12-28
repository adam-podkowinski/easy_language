import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnknownFailure extends Failure {}

abstract class UserFailure extends Failure {}

class UserCacheFailure extends UserFailure {}

class UserGetFailure extends UserFailure {}

class UserUnauthenticatedFailure extends UserFailure {
  final String errorMessage;

  UserUnauthenticatedFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class DictionariesFailure extends Failure {
  final Dictionaries dictionaries;

  DictionariesFailure(this.dictionaries);

  @override
  List<Object?> get props => [dictionaries];
}

class DictionariesCacheFailure extends DictionariesFailure {
  DictionariesCacheFailure(Dictionaries dictionaries) : super(dictionaries);
}

class DictionariesGetFailure extends DictionariesFailure {
  DictionariesGetFailure(Dictionaries dictionaries) : super(dictionaries);
}

abstract class DictionaryFailure extends Failure {
  final Dictionary? currentDictionary;

  DictionaryFailure(this.currentDictionary);

  @override
  List<Object?> get props => [currentDictionary];
}

class DictionaryCacheFailure extends DictionaryFailure {
  DictionaryCacheFailure(Dictionary? currentDictionary)
      : super(currentDictionary);
}

class DictionaryGetFailure extends DictionaryFailure {
  DictionaryGetFailure(Dictionary? currentDictionary)
      : super(currentDictionary);
}

abstract class FlashcardFailure extends Failure {}

class FlashcardTurnFailure extends FlashcardFailure {}

class FlashcardGetFailure extends FlashcardFailure {}
