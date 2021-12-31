import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/word.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  const tDateTimeString = '2021-07-25T19:59:50.709734';
  final tDateTime = DateTime.parse(tDateTimeString);

  final tWord = Word(
    wordForeign: 'gracias',
    wordTranslation: 'hello',
    updatedAt: tDateTime,
    id: 1,
    dictionaryId: 1,
    isTurned: false,
    learningStatus: LearningStatus.reviewing,
    timesReviewed: 0,
  );

  group('fromMap', () {
    test(
      'should return a valid model',
      () async {
        final Map jsonMap = cast(
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
            updatedAt: tDateTime,
            id: 1,
            dictionaryId: 1,
            isTurned: false,
            learningStatus: LearningStatus.reviewing,
            timesReviewed: 0,
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
            updatedAt: tDateTime,
            id: 1,
            dictionaryId: 1,
            isTurned: false,
            learningStatus: LearningStatus.reviewing,
            timesReviewed: 0,
          ),
        );
      },
    );
  });

  group('toMap', () {
    test(
      'should return a valid Map',
      () async {
        final Map tValidMap = cast(
          jsonDecode(
            fixture('word.json'),
          ),
        );

        final newMap = tWord.toMap();

        expect(newMap, tValidMap);
      },
    );
  });
}
