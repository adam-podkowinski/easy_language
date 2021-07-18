import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:language_picker/languages.dart';

abstract class WordBankRepository {
  Future<Either<Failure, WordBank>> addLanguageToWordBank(
    Language language, {
    List<Word>? initialWords,
  });

  Future<Either<Failure, WordBank>> editWordsList({
    required Language languageFrom,
    Language? languageTo,
    List<Word>? newWordList,
  });

  Future<Either<Failure, WordBank>> getWordBank();

  Future<Either<Failure, Language?>> getCurrentLanguage();

  Future<Either<Failure, Language>> changeCurrentLanguage(Language language);
}
