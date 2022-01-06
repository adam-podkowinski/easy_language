import 'package:easy_language/features/word_bank/data/models/dictionary_model.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:language_picker/languages.dart';

extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}

const Size screenSize = Size(393, 781);

String defaultURL = kDebugMode
    ? 'http://localhost:8000'
    : 'https://easy-language.herokuapp.com';
String baseURL = defaultURL;

String get api => '$baseURL/api/v1';

const wordBankPageId = '/dictionary';
const introductionPageId = '/introduction';
const flashcardsPageId = '/flashcards';
const settingsPageId = '/settings';
const cachedUserId = 'settings';
const cachedWordBankId = 'dictionary';
const cachedCurrentLanguageId = 'current_language';
const cachedCurrentFlashcardId = 'current_flashcard';
const emptyString = 'Empty';
const addNewWordTitle = 'Add a new word';
const editWordTitle = 'Edit a word';
const svgPrefix = 'assets/svgs';
const isStartupId = 'is_startup';

const idId = 'id';
const userIdId = 'user_id';
const languageId = 'language';
const updatedAtId = 'updated_at';
const createdAtId = 'created_at';

const resetPasswordContent =
    'To reset your password send an e-mail with your problem to an address below (click to copy). Your e-mail address has to be the same as the address associated with your account.';
const removeAccountContent =
    'To remove an account type in your credentials. Remember, your whole progress and all data will be lost forever.';
const contactAddress = 'easy.language.dev.contact@gmail.com';

const Map<String, String> pageTitlesFromIds = {
  wordBankPageId: 'Word Bank',
  introductionPageId: 'Introduction',
  flashcardsPageId: 'Flashcards',
  settingsPageId: 'Settings',
};

typedef Dictionaries = Map<Language, Dictionary>;
typedef DictionariesModel = Map<Language, DictionaryModel>;
