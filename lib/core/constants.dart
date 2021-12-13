import 'package:easy_language/features/word_bank/data/models/dictionary_model.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';

const Size screenSize = Size(393, 781);

const api = 'http://localhost:8000';

const wordBankPageId = '/dictionary';
const introductionPageId = '/introduction';
const flashcardsPageId = '/flashcards';
const settingsPageId = '/settings';
const cachedSettingsId = 'settings';
const cachedWordBankId = 'dictionary';
const cachedCurrentLanguageId = 'current_language';
const cachedCurrentFlashcardId = 'current_flashcard';
const emptyString = 'Empty';
const addNewWordTitle = 'Add a new word';
const editWordTitle = 'Edit a word';
const svgPrefix = 'assets/svgs';

const idId = 'id';
const userIdId = 'user_id';
const languageId = 'language';
const createdAtId = 'created_at';
const updatedAtId = 'updated_at';

const Map<String, String> pageTitlesFromIds = {
  wordBankPageId: 'Word Bank',
  introductionPageId: 'Introduction',
  flashcardsPageId: 'Flashcards',
  settingsPageId: 'Settings',
};

typedef Dictionaries = Map<Language, Dictionary>;
typedef DictionariesModel = Map<Language, DictionaryModel>;
