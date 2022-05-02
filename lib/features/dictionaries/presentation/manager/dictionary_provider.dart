import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/util/simplify_string.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/dictionaries/domain/entities/dictionary.dart';
import 'package:easy_language/features/dictionaries/domain/repositories/dictionary_repository.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:language_picker/languages.dart';

class DictionariesProvider extends ChangeNotifier {
  bool loading = true;

  final DictionariesRepository dictionaryRepository;

  Language? get currentLanguage => dictionaryRepository.currentLanguage;
  Dictionaries get dictionaries => dictionaryRepository.dictionaries;
  Dictionary? get currentDictionary => dictionaries[currentLanguage];

  InfoFailure? dictionariesFailure;
  InfoFailure? currentDictionaryFailure;

  Word? currentFlashcard;
  InfoFailure? flashcardFailure;
  int? flashcardIndex;

  late final User user;

  DictionariesProvider({
    required this.dictionaryRepository,
  });

  List<Word>? searchedWords;

  String searchPhrase = '';

  void clearError() {
    currentDictionaryFailure = null;
    dictionariesFailure = null;
    flashcardFailure = null;
  }

  int getLearningLength(Language language) {
    if (dictionaries.containsKey(language)) {
      return dictionaries[language]!
          .words
          .where(
            (element) => element.learningStatus == LearningStatus.learning,
          )
          .length;
    } else {
      return -1;
    }
  }

  int getReviewingLength(Language language) {
    if (dictionaries.containsKey(language)) {
      return dictionaries[language]!
          .words
          .where(
            (element) => element.learningStatus == LearningStatus.reviewing,
          )
          .length;
    } else {
      return -1;
    }
  }

  int getMasteredLength(Language language) {
    if (dictionaries.containsKey(language)) {
      return dictionaries[language]!
          .words
          .where(
            (element) => element.learningStatus == LearningStatus.mastered,
          )
          .length;
    } else {
      return -1;
    }
  }

  void _prepareMethod() {
    loading = true;
    dictionariesFailure = null;
    flashcardFailure = null;
    currentDictionaryFailure = null;
    notifyListeners();
  }

  void _finishMethod() {
    loading = false;
    notifyListeners();
  }

  List<Word>? searchWords(String? phraseToSearch) {
    var phrase = searchPhrase;

    if (phraseToSearch != null) {
      phrase = phraseToSearch;
      searchPhrase = phraseToSearch;
    }

    if (currentLanguage == null) {
      return null;
    }

    final wordsToSearchThrough = currentDictionary?.words;

    if (wordsToSearchThrough == null) {
      return null;
    }

    searchedWords = wordsToSearchThrough
        .where(
          (e) =>
              simplifyString(e.wordForeign).contains(
                simplifyString(phrase),
              ) ||
              simplifyString(e.wordTranslation).contains(
                simplifyString(phrase),
              ),
        )
        .toList();

    notifyListeners();
    return null;
  }

  Future initDictionaryProvider(User loggedInUser) async {
    _prepareMethod();

    user = loggedInUser;

    dictionariesFailure = await dictionaryRepository.initDictionaries(
      loggedInUser,
    );

    currentDictionaryFailure =
        await dictionaryRepository.initCurrentDictionary(user);

    _finishMethod();
  }

  Future addDictionary(Language lang) async {
    _prepareMethod();

    dictionariesFailure = await dictionaryRepository.addDictionary(user, lang);

    _finishMethod();
  }

  Future removeDictionary(Language lang) async {
    _prepareMethod();

    dictionariesFailure = await dictionaryRepository.removeDictionary(
      user,
      lang,
    );

    currentDictionaryFailure =
        await dictionaryRepository.initCurrentDictionary(user);

    _finishMethod();
  }

  Future addWord(
    BuildContext context,
    Map wordToAddMap,
  ) async {
    _prepareMethod();

    if (currentLanguage != null) {
      if (currentDictionary != null) {
        dictionariesFailure = await dictionaryRepository.addWord(
          user,
          wordToAddMap,
        );
      }
    }

    _finishMethod();
  }

  Future changeCurrentDictionary(
    BuildContext context,
    Language? language,
  ) async {
    _prepareMethod();

    if (language == null) {
      _finishMethod();
      throw UnexpectedException();
    }

    if (dictionaries[language] != null) {
      currentDictionaryFailure =
          await dictionaryRepository.changeCurrentDictionary(
        user,
        language,
      );
    }

    _finishMethod();
  }

  Future editWord(
    Word oldWord,
    Map changedMap, {
    bool? searching,
  }) async {
    dictionariesFailure = await dictionaryRepository.editWord(
      user,
      oldWord.id,
      changedMap,
    );

    if (searching ?? false) {
      searchWords(null);
    }

    _finishMethod();
  }

  Future removeWord(
    Word wordToRemove, {
    bool? searching,
  }) async {
    _prepareMethod();

    dictionariesFailure = await dictionaryRepository.removeWord(
      user,
      wordToRemove,
    );

    if (searching ?? false) {
      searchWords(null);
    }

    _finishMethod();
  }

  void getCurrentFlashcard() {
    currentFlashcard = dictionaryRepository.getCurrentFlashcard(user);
    flashcardIndex = dictionaryRepository.getFlashcardIndex();
  }

  Future getNextFlashcard() async {
    _prepareMethod();
    currentFlashcard = dictionaryRepository.getNextFlashcard(user);
    flashcardIndex = dictionaryRepository.getFlashcardIndex();
    _finishMethod();
  }
}
