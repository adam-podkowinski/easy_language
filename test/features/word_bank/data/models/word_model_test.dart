import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/features/word_bank/data/models/word_model.dart';
import 'package:easy_language/features/word_bank/domain/entities/word.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tWordModel = WordModel(
    wordForeign: 'gracias',
    wordTranslation: 'hello',
  );

  test(
    'should be a subclass of Word entity',
    () async {
      expect(tWordModel, isA<Word>());
    },
  );

  group('fromMap', () {
    test(
      'should return a valid model',
      () async {
        final Map<dynamic, dynamic> jsonMap = cast(
          jsonDecode(
            fixture('word.json'),
          ),
        );

        final result = WordModel.fromMap(jsonMap);
        expect(result, tWordModel);
      },
    );
  });

  group('copyWithMap', () {
    test(
      'should return a new word model with replaced value from map',
      () async {
        const Map<String, String> tMap = {
          Word.wordForeignId: 'szkola',
        };

        final tNewWordModel = tWordModel.copyWithMap(tMap);

        expect(
          tNewWordModel,
          const WordModel(wordForeign: 'szkola', wordTranslation: 'hello'),
        );

        const Map<String, String> tMapSecond = {
          Word.wordForeignId: 'szkola',
          Word.wordTranslationId: 'school',
        };

        final tNewWordModelSecond = tWordModel.copyWithMap(tMapSecond);
        expect(
          tNewWordModelSecond,
          const WordModel(wordForeign: 'szkola', wordTranslation: 'school'),
        );
      },
    );
  });

  group('toMap', () {
    test(
      'should return a valid Map',
      () async {
        const Map<String, String> tValidMap = {
          Word.wordForeignId: 'gracias',
          Word.wordTranslationId: 'hello',
        };

        final newMap = tWordModel.toMap();

        expect(newMap, tValidMap);
      },
    );
  });

  group('wordToMap', () {
    test(
      'should return a valid Map from passed Word entity',
      () async {
        const tWordEntity =
            Word(wordForeign: 'gracias', wordTranslation: 'hello');

        const tWordMap = {
          Word.wordForeignId: 'gracias',
          Word.wordTranslationId: 'hello',
        };

        final tNewMap = WordModel.wordToMap(tWordEntity);

        expect(tNewMap, tWordMap);
      },
    );
  });
}
