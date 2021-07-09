import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class SortWordList implements Usecase<WordBank, SortWordListParams> {
  final WordBankRepository repository;

  SortWordList(this.repository);

  @override
  Future<Either<Failure, WordBank>> call(SortWordListParams params) {
    return repository.sortWordList(params.language);
  }
}

class SortWordListParams extends Equatable {
  final Language language;

  const SortWordListParams({required this.language});

  @override
  List<Object?> get props => [language];
}
