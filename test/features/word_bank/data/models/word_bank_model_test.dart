import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tWordBank = WordBankModel(dictionaries: {
    Languages.polish: const [
      Word(wordForeign: 'gracias', wordTranslation: 'hello'),
      Word(wordForeign: 'dzień', wordTranslation: 'day')
    ],
  });

  group('fromMap', () {
    test(
      'should return a valid WordBankModel from a map',
      () async {
        final Map<dynamic, dynamic> tMap =
            cast(jsonDecode(fixture('word_bank.json')));

        final tNewWordBank = WordBankModel.fromMap(tMap);

        expect(tNewWordBank, tWordBank);
      },
    );
  });

  group('toMap', () {
    test(
      'should return a valid map from a WordBankModel',
      () async {
        final tMap = {
          "pl": [
            {Word.wordForeignId: 'gracias', Word.wordTranslationId: 'hello'},
            {Word.wordForeignId: 'dzień', Word.wordTranslationId: 'day'},
          ]
        };

        final tToMap = tWordBank.toMap();

        expect(tToMap, tMap);
      },
    );
  });
}
