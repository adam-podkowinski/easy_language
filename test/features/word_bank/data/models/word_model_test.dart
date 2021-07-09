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
        print(jsonDecode(fixture('word.json')));
        final Map<String, String> jsonMap = cast(
          jsonDecode(
            fixture('word.json'),
          ).cast<String, String>() as Map<String, String>,
        );

        final result = WordModel.fromMap(jsonMap);
        expect(result, tWordModel);
      },
    );
  });
}
