import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/word_bank/data/models/dictionary_model.dart';
import 'package:language_picker/languages.dart';

abstract class DictionaryRepository {
  DictionariesModel dictionaries = {};
  Language? currentLanguage;
  DictionaryModel? get currentDictionary;

  Future<InfoFailure?> addDictionary(
    User user,
    Language language,
  );

  Future<InfoFailure?> addWord(User user, Map wordMap);

  Future<InfoFailure?> changeCurrentDictionary(
    User user,
    Language language,
  );

  Future<InfoFailure?> editWord(
    User user,
    int id,
    Map changedProperties,
  );

  Future<List<Word>> fetchCurrentDictionaryWords(User user);

  Word? getCurrentFlashcard(User user);

  int? getFlashcardIndex();

  Word? getNextFlashcard(User user);

  Future<InfoFailure?> initCurrentDictionary(User user);

  Future<InfoFailure?> initDictionaries(User user);

  void logout();

  Future<InfoFailure?> removeDictionary(
    User user,
    Language language,
  );

  Future<InfoFailure?> removeWord(
    User user,
    Word wordToRemove,
  );
}
