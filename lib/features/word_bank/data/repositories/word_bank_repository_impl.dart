import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/word_bank/data/data_sources/word_bank_local_data_source.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:easy_language/features/word_bank/domain/entities/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:language_picker/languages.dart';

class WordBankRepositoryImpl implements WordBankRepository {
  bool _initialWordBank = true;
  bool _initialCurrentLanguage = true;
  WordBankModel _wordBank = const WordBankModel(dictionaries: {});
  Language? _currentLanguage;

  final WordBankLocalDataSource localDataSource;

  WordBankRepositoryImpl(this.localDataSource);

  Future<void> _ensureWordBankInitialized() async {
    if (_initialWordBank) {
      await getWordBank();
    }
  }

  Future<void> _ensureCurrentLanguageInitialized() async {
    if (_initialCurrentLanguage) {
      await getCurrentLanguage();
    }
  }

  @override
  Future<Either<Failure, WordBank>> addLanguageToWordBank(
    Language language, {
    List<Word>? initialWords,
  }) {
    // TODO: implement addLanguageToWordBank
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Language>> changeCurrentLanguage(Language language) {
    // TODO: implement changeCurrentLanguage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, WordBank>> editWordsList({
    required Language languageFrom,
    Language? languageTo,
    List<Word>? newWordList,
  }) {
    // TODO: implement editWordsList
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Language?>> getCurrentLanguage() async {
    try {
      if (_initialCurrentLanguage) {
        final dbLang = await localDataSource.getLocalCurrentLanguage();
        _currentLanguage = dbLang;
        _initialCurrentLanguage = false;
      }
    } on CacheException {
      _initialCurrentLanguage = false;
      return Left(LanguageGetFailure(_currentLanguage));
    }

    return Right(_currentLanguage);
  }

  @override
  Future<Either<Failure, WordBank>> getWordBank() async {
    try {
      if (_initialWordBank) {
        _wordBank = await localDataSource.getLocalWordBank();
        _initialWordBank = false;
      }
    } on CacheException {
      _initialWordBank = false;
      return Left(WordBankGetFailure(_wordBank));
    }
    return Right(_wordBank);
  }
}
