import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/word.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  const tWord = Word(
    wordForeign: 'gracias',
    wordTranslation: 'hello',
  );

  test(
    'should be a subclass of Word entity',
    () async {
      expect(tWord, isA<Word>());
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

        final result = Word.fromMap(jsonMap);
        expect(result, tWord);
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

        final tNewWord = tWord.copyWithMap(tMap);

        expect(
          tNewWord,
          const Word(wordForeign: 'szkola', wordTranslation: 'hello'),
        );

        const Map<String, String> tMapSecond = {
          Word.wordForeignId: 'szkola',
          Word.wordTranslationId: 'school',
        };

        final tNewWordSecond = tWord.copyWithMap(tMapSecond);
        expect(
          tNewWordSecond,
          const Word(wordForeign: 'szkola', wordTranslation: 'school'),
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

        final newMap = tWord.toMap();

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

        final tNewMap = Word.wordToMap(tWordEntity);

        expect(tNewMap, tWordMap);
      },
    );
  });
}
