import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/word.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final tWord = Word(
    wordForeign: 'gracias',
    wordTranslation: 'hello',
    editDate: DateTime.now(),
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
          Word(
            wordForeign: 'szkola',
            wordTranslation: 'hello',
            editDate: DateTime.now(),
          ),
        );

        const Map<String, String> tMapSecond = {
          Word.wordForeignId: 'szkola',
          Word.wordTranslationId: 'school',
        };

        final tNewWordSecond = tWord.copyWithMap(tMapSecond);
        expect(
          tNewWordSecond,
          Word(
            wordForeign: 'szkola',
            wordTranslation: 'school',
            editDate: DateTime.now(),
          ),
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
}
