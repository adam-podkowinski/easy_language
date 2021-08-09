import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnknownFailure extends Failure {}

abstract class SettingsFailure extends Failure {
  final Settings settings;

  SettingsFailure(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SettingsCacheFailure extends SettingsFailure {
  SettingsCacheFailure(Settings settings) : super(settings);
}

class SettingsGetFailure extends SettingsFailure {
  SettingsGetFailure(Settings settings) : super(settings);
}

abstract class WordBankFailure extends Failure {
  final WordBank wordBank;

  WordBankFailure(this.wordBank);

  @override
  List<Object?> get props => [wordBank];
}

class WordBankCacheFailure extends WordBankFailure {
  WordBankCacheFailure(WordBank wordBank) : super(wordBank);
}

class WordBankGetFailure extends WordBankFailure {
  WordBankGetFailure(WordBank wordBank) : super(wordBank);
}

abstract class LanguageFailure extends Failure {
  final Language? currentLanguage;

  LanguageFailure(this.currentLanguage);

  @override
  List<Object?> get props => [currentLanguage];
}

class LanguageCacheFailure extends LanguageFailure {
  LanguageCacheFailure(Language currentLanguage) : super(currentLanguage);
}

class LanguageGetFailure extends LanguageFailure {
  LanguageGetFailure(Language? currentLanguage) : super(currentLanguage);
}

abstract class FlashcardFailure extends Failure {}

class FlashcardTurnFailure extends FlashcardFailure {}

class FlashcardGetFailure extends FlashcardFailure {}
