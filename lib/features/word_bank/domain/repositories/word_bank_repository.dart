import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:language_picker/languages.dart';

abstract class DictionaryRepository {
  Future<Either<Failure, Dictionaries>> addDictionary(
    Language language, {
    List<Word>? initialWords,
  });

  Future<Either<Failure, Dictionaries>> addWord(Map<String, dynamic> wordMap);

  Future<Either<Failure, Dictionaries>> removeWord(Word wordToRemove);

  Future<Either<Failure, Dictionaries>> editWord(
    int id,
    Map<String, dynamic> newWordMap,
  );

  Future<Either<Failure, Dictionaries>> removeDictionary(
    Language language,
  );

  Future<Either<Failure, Dictionaries>> getWordBank();

  Future<Either<Failure, Dictionaries>> fetchWordBankRemotely();

  Future<Either<Failure, Dictionary?>> getCurrentDictionary();

  Future<Either<Failure, Dictionary?>> fetchCurrentDictionaryRemotely();

  Future<List<Word>> fetchCurrentDictionaryWords();

  Future<Either<Failure, Dictionary>> changeCurrentDictionary(
    Language language,
  );

  Future saveWordBank();

  Future saveCurrentLanguage();
}
