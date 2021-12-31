import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:language_picker/languages.dart';

abstract class DictionaryRepository {
  void logout();

  Future<Either<Failure, Dictionaries>> addDictionary(
    User user,
    Language language,
  );

  Future<Either<Failure, Dictionaries>> addWord(User user, Map wordMap);

  Future<Either<Failure, Dictionaries>> removeWord(
    User user,
    Word wordToRemove,
  );

  Future<Either<Failure, Dictionaries>> editWord(
    User user,
    int id,
    Map changedProperties,
  );

  Future<Either<Failure, Dictionaries>> removeDictionary(
    User user,
    Language language,
  );

  Future<Either<Failure, Dictionaries>> initDictionaries(User user);

  Future<Either<Failure, Dictionary?>> initCurrentDictionary(User user);

  Future<List<Word>> fetchCurrentDictionaryWords(User user);

  Future<Either<Failure, Dictionary>> changeCurrentDictionary(
    User user,
    Language language,
  );

  Word? getCurrentFlashcard();

  Future<Word?> getNextFlashcard(User user);

  Future<Either<Failure, Word>> turnCurrentFlashcard(User user);

  int? getFlashcardIndex();
}
