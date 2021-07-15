// TODO: write tests for WordBankRepositoryImpl
import 'package:easy_language/features/word_bank/data/data_sources/word_bank_local_data_source.dart';
import 'package:easy_language/features/word_bank/data/repositories/word_bank_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWordBankLocalDataSource extends Mock
    implements WordBankLocalDataSourceImpl {}

void main() {
  late final WordBankRepositoryImpl repository;
  late final MockWordBankLocalDataSource dataSource;

  setUp(() {
    dataSource = MockWordBankLocalDataSource();
    repository = WordBankRepositoryImpl(dataSource);
  });

  group('getWordBank', () {});
  group('getCurrentLanguage', () {});
}
