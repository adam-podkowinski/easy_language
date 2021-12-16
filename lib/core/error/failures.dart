import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnknownFailure extends Failure {}

abstract class SettingsFailure extends Failure {
  final User settings;

  SettingsFailure(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SettingsCacheFailure extends SettingsFailure {
  SettingsCacheFailure(User settings) : super(settings);
}

class SettingsGetFailure extends SettingsFailure {
  SettingsGetFailure(User settings) : super(settings);
}

abstract class DictionariesFailure extends Failure {
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
