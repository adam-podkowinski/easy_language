import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/features/flashcards/data/models/flashcard_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';

import '../../../../fixtures/fixture_reader.dart';

// TODO: write tests for flashcard model
void main() {
  final tFlashcard = FlashcardModel(
    isTurned: false,
    wordIndex: 0,
    wordLanguage: Languages.polish,
  );

  group('fromMap', () {
    test(
      'Should return a valid flashcard from a map',
      () async {
        final Map<dynamic, dynamic> tMap = cast(
          jsonDecode(
            fixture('flashcard.json'),
          ),
        );

        final tNewFlashcard = FlashcardModel.fromMap(tMap);

        expect(tNewFlashcard, tFlashcard);
      },
    );
  });

  group('toMap', () {
    test(
      'should return a valid map from a FlashcardModel',
      () async {
        final Map<dynamic, dynamic> tMap = cast(
          jsonDecode(
            fixture(
              'flashcard.json',
            ),
          ),
        );

        final tToMap = tFlashcard.toMap();
        expect(tToMap, tMap);
      },
    );
  });
}
