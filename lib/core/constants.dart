import 'package:dio/dio.dart';
import 'package:easy_language/features/dictionaries/data/models/dictionary_model.dart';
import 'package:easy_language/features/dictionaries/domain/entities/dictionary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:language_picker/languages.dart';

extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}

extension IsOkDio on Response {
  bool get ok {
    if (statusCode == null) return false;
    return (statusCode! ~/ 100) == 2;
  }
}

const Size screenSize = Size(393, 781);

String defaultURL = kDebugMode
    ? 'http://192.168.3.23:3000'
    : 'https://easy-language.herokuapp.com';
String baseURL = defaultURL;

String get api => baseURL;

const dictionariesPageId = '/dictionaries';
const introductionPageId = '/introduction';
const flashcardsPageId = '/flashcards';
const settingsPageId = '/settings';
const cachedUserId = 'settings';
const cachedDictionariesId = 'dictionary';
const cachedCurrentLanguageId = 'currentLanguage';
const cachedCurrentFlashcardId = 'currentFlashcard';
const cachedApiBoxId = 'apiBox';
const emptyString = 'Empty';
const addNewWordTitle = 'Add a new word';
const editWordTitle = 'Edit a word';
const svgPrefix = 'assets/svgs';
const isStartupId = 'isStartup';
const oauthClientIdDesktop = 'OAUTH_CLIENT_ID_DESKTOP';
const oauthClientIdWeb = 'OAUTH_CLIENT_ID_WEB';

const idId = 'id';
const userIdId = 'useraId';
const languageId = 'language';
const updatedAtId = 'updatedAt';

const resetPasswordContent =
    'To reset your password send an e-mail with your problem to an address below (click to copy). Your e-mail address has to be the same as the address associated with your account.';
const removeAccountContent =
    'To remove an account type in your credentials. Remember, your whole progress and all data will be lost forever.';
const contactAddress = 'easy.language.dev.contact@gmail.com';

const Map<String, String> pageTitlesFromIds = {
  dictionariesPageId: 'Word Bank',
  introductionPageId: 'Introduction',
  flashcardsPageId: 'Flashcards',
  settingsPageId: 'Settings',
};

typedef Dictionaries = Map<Language, Dictionary>;
typedef DictionariesModel = Map<Language, DictionaryModel>;
