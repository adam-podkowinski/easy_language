void main() {

}
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:dartz/dartz.dart';
// import 'package:easy_language/core/constants.dart';
// import 'package:easy_language/core/error/exceptions.dart';
// import 'package:easy_language/core/word.dart';
// import 'package:easy_language/features/dictionary/data/data_sources/word_bank_local_data_source.dart';
// import 'package:easy_language/features/dictionary/data/models/word_bank_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hive/hive.dart';
// import 'package:language_picker/languages.dart';
// import 'package:mocktail/mocktail.dart';
//
// import '../../../../fixtures/fixture_reader.dart';
//
// class MockBox extends Mock implements Box {}
//
// void main() {
//   late WordBankLocalDataSourceImpl dataSource;
//   late MockBox mockBox;
//
//   setUpAll(() {
//     Hive.init(Directory.systemTemp.path);
//   });
//
//   setUp(() {
//     mockBox = MockBox();
//     dataSource = WordBankLocalDataSourceImpl(
//       wordBankBox: mockBox,
//     );
//   });
//
//   group('getLocalWordBank', () {
//     final tWordBankModel = WordBankModel.fromMap(
//       jsonDecode(
//         fixture('dictionary.json'),
//       ) as Map,
//     );
//     test(
//       '''
//       should return WordBankModel from Hive
//       when there is one in the cache''',
//       () async {
//         when(() => mockBox.get(cachedWordBankId)).thenReturn(
//           cast(jsonDecode(fixture('dictionary.json'))),
//         );
//         when(() => mockBox.isEmpty).thenReturn(false);
//         when(() => mockBox.isNotEmpty).thenReturn(true);
//
//         final result = await dataSource.getLocalWordBank();
//
//         verify(() => mockBox.get(cachedWordBankId));
//         expect(result, equals(tWordBankModel));
//       },
//     );
//
//     test(
//       'should throw a CacheException when there is not a cached value',
//       () async {
//         when(() => mockBox.toMap()).thenReturn({});
//         when(() => mockBox.get(any())).thenReturn(null);
//         when(() => mockBox.isEmpty).thenReturn(true);
//         when(() => mockBox.isNotEmpty).thenReturn(false);
//
//         final call = dataSource.getLocalWordBank;
//
//         expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
//       },
//     );
//   });
//
//   group('cacheWordBank', () {
//     final tWordBankModel = WordBankModel(dictionaries: {
//       Languages.polish: [
//         Word(
//           wordForeign: 'gracias',
//           wordTranslation: 'hello',
//           editDate: DateTime.now(),
//           id: 'id',
//         )
//       ],
//     },);
//
//     test(
//       'should call Hive box to cache the data',
//       () async {
//         when(() => mockBox.put(any(), any())).thenAnswer((_) => Future.value());
//
//         await dataSource.cacheWordBank(tWordBankModel);
//
//         final expectedMap = tWordBankModel.toMap();
//
//         verify(
//           () => mockBox.put(cachedWordBankId, expectedMap),
//         );
//       },
//     );
//   });
//
//   group(
//     'getLocalCurrentLanguage',
//     () {
//       final tLanguage = Languages.polish;
//       test(
//         'should return a Language when one is cached in box',
//         () async {
//           when(() => mockBox.isEmpty).thenReturn(false);
//           when(() => mockBox.isNotEmpty).thenReturn(true);
//           when(() => mockBox.get(cachedCurrentLanguageId))
//               .thenReturn(tLanguage.isoCode);
//
//           final result = await dataSource.getLocalCurrentLanguage();
//           expect(result, tLanguage);
//         },
//       );
//
//       test(
//         'should throw a CacheException when there is no cached value',
//         () async {
//           when(() => mockBox.isEmpty).thenReturn(true);
//           when(() => mockBox.isNotEmpty).thenReturn(false);
//           when(() => mockBox.get(any())).thenReturn(null);
//
//           final call = dataSource.getLocalCurrentLanguage;
//           expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
//         },
//       );
//
//       test(
//         '''
//           should throw a CacheException when there is a cached value
//            but its unable to cast it to a valid string''',
//         () async {
//           when(() => mockBox.isEmpty).thenReturn(false);
//           when(() => mockBox.isNotEmpty).thenReturn(true);
//           when(() => mockBox.get(any())).thenReturn(const ButtonStyle());
//
//           final call = dataSource.getLocalCurrentLanguage;
//           expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
//         },
//       );
//
//       test(
//         '''
//           should throw a CacheException when there is a cached value
//            but language is not valid''',
//         () async {
//           when(() => mockBox.isEmpty).thenReturn(false);
//           when(() => mockBox.isNotEmpty).thenReturn(true);
//           when(() => mockBox.get(any())).thenReturn('lol');
//
//           final call = dataSource.getLocalCurrentLanguage;
//           expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
//         },
//       );
//     },
//   );
//
//   group('cacheCurrentLanguage', () {
//     final tLanguage = Languages.polish;
//
//     test(
//       'should cache a language by forwarding a call to a hive box',
//       () async {
//         when(() => mockBox.put(any(), any())).thenAnswer((_) async => Future);
//         await dataSource.cacheCurrentLanguage(tLanguage);
//         verify(() => mockBox.put(cachedCurrentLanguageId, tLanguage.isoCode));
//       },
//     );
//   });
// }
