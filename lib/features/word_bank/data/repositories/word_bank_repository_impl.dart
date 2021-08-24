// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/data/data_sources/word_bank_local_data_source.dart';
import 'package:easy_language/features/word_bank/data/data_sources/word_bank_remote_data_source.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:language_picker/languages.dart';

class WordBankRepositoryImpl implements WordBankRepository {
  bool _initialWordBank = true;
  bool _initialCurrentLanguage = true;
  WordBankModel _wordBank = WordBankModel(dictionaries: {});
  Language? _currentLanguage;

  final WordBankLocalDataSource localDataSource;
  final WordBankRemoteDataSource remoteDataSource;

  WordBankRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

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
  }) async {
    try {
      await _ensureWordBankInitialized();
      if (_wordBank.dictionaries[language] == null) {
        _wordBank.dictionaries[language] = initialWords ?? [];
      }

      localDataSource.cacheWordBank(_wordBank);
      remoteDataSource.saveWordBank(_wordBank);

      await changeCurrentLanguage(language);

      return Right(_wordBank);
    } catch (_) {
      return Left(WordBankCacheFailure(_wordBank));
    }
  }

  @override
  Future<Either<Failure, WordBank>> removeLanguageFromWordBank(
    Language language,
  ) async {
    try {
      await _ensureWordBankInitialized();
      if (_wordBank.dictionaries[language] != null) {
        _wordBank.dictionaries.removeWhere((key, value) => key == language);
      }

      localDataSource.cacheWordBank(_wordBank);
      remoteDataSource.saveWordBank(_wordBank);

      if (_wordBank.dictionaries.isNotEmpty) {
        await changeCurrentLanguage(_wordBank.dictionaries.keys.first);
      } else {
        _currentLanguage = null;
      }

      return Right(_wordBank);
    } catch (_) {
      return Left(WordBankCacheFailure(_wordBank));
    }
  }

  @override
  Future<Either<Failure, Language>> changeCurrentLanguage(
    Language language,
  ) async {
    try {
      await _ensureCurrentLanguageInitialized();

      _currentLanguage = language;

      localDataSource.cacheCurrentLanguage(_currentLanguage);
      remoteDataSource.saveCurrentLanguage(_currentLanguage!);
    } catch (_) {
      // we are sure current language is not null because we asign it previously
      // with a non-nullable function argument
      // and _ensureCurrentLanguageInitialized can't throw an error
      return Left(LanguageCacheFailure(_currentLanguage!));
    }
    return Right(_currentLanguage!);
  }

  /// Edit word list of a word bank
  /// You can change a language and a word list content
  @override
  Future<Either<Failure, WordBank>> editWordsList({
    required Language languageFrom,
    Language? languageTo,
    List<Word>? newWordList,
  }) async {
    try {
      await _ensureWordBankInitialized();

      // Make sure a word list that we want to change exists
      if (_wordBank.dictionaries[languageFrom] == null) {
        return Left(WordBankCacheFailure(_wordBank));
      }

      // Change words list content
      if (newWordList != null) {
        _wordBank.dictionaries[languageFrom] = newWordList;
      }

      // Change language of a word list
      if (languageTo != null) {
        // If new language place in dictionary is null we have to create it
        if (_wordBank.dictionaries[languageTo] == null) {
          _wordBank.dictionaries[languageTo] =
              _wordBank.dictionaries[languageFrom]!;
        }

        // Otherwise we just append it (so old data from langaugeTo word list
        // will not be erased
        else {
          _wordBank.dictionaries[languageTo]!.addAll(
            _wordBank.dictionaries[languageFrom]!,
          );
        }
        _wordBank.dictionaries[languageFrom]!.clear();
      }

      localDataSource.cacheWordBank(_wordBank);
      remoteDataSource.saveWordBank(_wordBank);
    } catch (_) {
      return Left(WordBankCacheFailure(_wordBank));
    }

    return Right(_wordBank);
  }

  @override
  Future<Either<Failure, Language?>> getCurrentLanguage() async {
    try {
      if (_initialCurrentLanguage) {
        final dbLang = await localDataSource.getLocalCurrentLanguage();
        _currentLanguage = dbLang;
        _initialCurrentLanguage = false;
      }
    } catch (_) {
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
    } catch (_) {
      _initialWordBank = false;
      return Left(WordBankGetFailure(_wordBank));
    }

    return Right(_wordBank);
  }

  @override
  Future<Either<Failure, WordBank>> fetchWordBankRemotely() async {
    try {
      _wordBank = await remoteDataSource.fetchWordBank();
      localDataSource.cacheWordBank(_wordBank);
      _initialWordBank = false;
      return Right(_wordBank);
    } catch (_) {
      _initialWordBank = false;
      _wordBank = WordBankModel(dictionaries: {});
      localDataSource.cacheWordBank(_wordBank);
      return Left(WordBankGetFailure(_wordBank));
    }
  }

  @override
  Future<Either<Failure, Language?>> fetchCurrentLanguageRemotely() async {
    try {
      _currentLanguage = await remoteDataSource.fetchCurrentLanguage();
      localDataSource.cacheCurrentLanguage(_currentLanguage);
      _initialCurrentLanguage = false;
      return Right(_currentLanguage);
    } catch (_) {
      _initialCurrentLanguage = false;
      _currentLanguage = null;
      localDataSource.cacheCurrentLanguage(_currentLanguage);
      return Left(LanguageGetFailure(_currentLanguage));
    }
  }

  @override
  Future saveCurrentLanguage() async {
    try {
      if (_currentLanguage != null) {
        localDataSource.cacheCurrentLanguage(_currentLanguage);
        await remoteDataSource.saveCurrentLanguage(_currentLanguage!);
      }
    } catch (_) {
      return;
    }
  }

  @override
  Future saveWordBank() async {
    try {
      localDataSource.cacheWordBank(_wordBank);
      await remoteDataSource.saveWordBank(_wordBank);
    } catch (_) {
      return;
    }
  }
}
