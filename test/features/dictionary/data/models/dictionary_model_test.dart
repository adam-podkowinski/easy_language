import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/data/models/dictionary_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tDateTime = DateTime.parse("2021-12-11T21:55:20.000000Z");

  final tDictionary = DictionaryModel(
    id: 1,
    words: [
      Word(
        wordForeign: 'gracias',
        wordTranslation: 'hello',
        // createdAt: tDateTime,
        updatedAt: tDateTime,
        id: 1,
        dictionaryId: 1,
      ),
      Word(
        wordForeign: 'siema',
        wordTranslation: 'elo',
        // createdAt: tDateTime,
        updatedAt: tDateTime,
        id: 2,
        dictionaryId: 1,
      ),
    ],
    language: Languages.english,
    updatedAt: tDateTime,
    shouldFetchWords: false,
  );

  group('fromMap', () {
    test(
      'should return a valid DictionaryModel from a given map',
      () {
        final Map tMap = cast(jsonDecode(fixture('dictionary.json')));

        final tNewDictionary = DictionaryModel.fromMap(
          tMap,
          shouldFetch: false,
        );

        expect(tNewDictionary, tDictionary);
      },
    );

    test('should rethrow a type error when given bad data', () {
      final Map tMap = {};

      expect(
        () => DictionaryModel.fromMap(tMap, shouldFetch: false),
        throwsA(
          isInstanceOf<TypeError>(),
        ),
      );
    });
  });

  group('toMap', () {
    test(
      'should return a valid DictionaryModel from a given map',
      () {
        final Map tMap = cast(jsonDecode(fixture('dictionary.json')));

        final tNewDictionary = DictionaryModel.fromMap(
          tMap,
          shouldFetch: false,
        );

        expect(tNewDictionary, tDictionary);
      },
    );
  });
}
