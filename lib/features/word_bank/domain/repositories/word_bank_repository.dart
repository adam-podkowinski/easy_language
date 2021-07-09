import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/word_bank/domain/entities/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:language_picker/languages.dart';

abstract class WordBankRepository {
  Future<Either<Failure, Language>> getCurrentLanguge();

  Future<Either<Failure, WordBank>> addLanguage(
    Language language, {
    List<Word>? initialWords,
  });

  Future<Either<Failure, WordBank>> changeLanguage({
    required Language languageFrom,
    required Language languageTo,
  });

  Future<Either<Failure, WordBank>> addWord(
    Language language, {
    required Word word,
  });

  Future<Either<Failure, WordBank>> removeWord(
    Language language, {
    int index,
  });

  Future<Either<Failure, WordBank>> sortWordList(Language language);

  Future<Either<Failure, WordBank>> moveWordList(
    Language language, {
    List<Word> newWordList,
  });
}
