import 'dart:convert';

import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/word_bank/data/data_sources/word_bank_local_data_source.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:easy_language/features/word_bank/data/models/word_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late WordBankLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = WordBankLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLocalWordBank', () {
    final tWordBankModel = WordBankModel.fromMap(
      jsonDecode(
        fixture('word_bank.json'),
      ).cast<String, dynamic>() as Map<String, dynamic>,
    );
    test(
      '''
      should return WordBankModel from SharedPreferences
      when there is one in the cache''',
      () async {
        when(() => mockSharedPreferences.getString(any())).thenReturn(
          fixture('word_bank.json'),
        );

        final result = await dataSource.getLocalWordBank();

        verify(() => mockSharedPreferences.getString(cachedWordBankId));
        expect(result, equals(tWordBankModel));
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);

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
      'should call SharedPreferences to cache the data',
      () async {
        when(() => mockSharedPreferences.setString(any(), any()))
            .thenAnswer((_) => Future.value(true));

        await dataSource.cacheWordBank(tWordBankModel);

        final expectedJsonString = jsonEncode(tWordBankModel.toMap());

        verify(
          () => mockSharedPreferences.setString(
              cachedWordBankId, expectedJsonString),
        );
      },
    );
  });
}
