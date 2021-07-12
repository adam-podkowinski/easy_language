import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/word_bank/data/data_sources/word_bank_local_data_source.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:easy_language/features/word_bank/data/models/word_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:language_picker/languages.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockBox extends Mock implements Box {}

void main() {
  late WordBankLocalDataSourceImpl dataSource;
  late MockBox mockBox;

  setUpAll(() {
    Hive.init(Directory.systemTemp.path);
  });

  setUp(() {
    mockBox = MockBox();
    dataSource = WordBankLocalDataSourceImpl(
      wordBankBox: mockBox,
    );
  });

  group('getLocalWordBank', () {
    final tWordBankModel = WordBankModel.fromMap(
      jsonDecode(
        fixture('word_bank.json'),
      ) as Map,
    );
    test(
      '''
      should return WordBankModel from Hive
      when there is one in the cache''',
      () async {
        when(() => mockBox.toMap()).thenReturn(
          cast(jsonDecode(fixture('word_bank.json'))),
        );
        when(() => mockBox.isEmpty).thenReturn(false);
        when(() => mockBox.isNotEmpty).thenReturn(true);

        final result = await dataSource.getLocalWordBank();

        verify(() => mockBox.toMap());
        expect(result, equals(tWordBankModel));
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        when(() => mockBox.toMap()).thenReturn({});
        when(() => mockBox.isEmpty).thenReturn(true);
        when(() => mockBox.isNotEmpty).thenReturn(false);

        final call = dataSource.getLocalWordBank;

        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheWordBank', () {
    final tWordBankModel = WordBankModel(dictionaries: {
      Languages.polish: const [
        WordModel(wordForeign: 'gracias', wordTranslation: 'hello')
      ],
    });

    test(
      'should call Hive box to cache the data',
      () async {
        when(() => mockBox.putAll(any())).thenAnswer((_) => Future.value());

        await dataSource.cacheWordBank(tWordBankModel);

        final expectedMap = tWordBankModel.toMap();

        verify(
          () => mockBox.putAll(expectedMap),
        );
      },
    );
  });

  // TODO: write tests for getLocalCurrentLanguage
  // TODO: write tests for cacheCurrentLanguage
}
