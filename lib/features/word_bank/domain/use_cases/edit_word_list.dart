import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class EditWordList implements Usecase<WordBank, EditWordListParams> {
  final WordBankRepository repository;

  EditWordList(this.repository);

  @override
  Future<Either<Failure, WordBank>> call(EditWordListParams params) {
    return repository.editWordsList(
      languageFrom: params.languageFrom,
      languageTo: params.languageTo,
      newWordList: params.newWordList,
    );
  }
}

class EditWordListParams extends Equatable {
  final Language languageFrom;
  final Language? languageTo;
  final List<Word>? newWordList;

  const EditWordListParams({
    required this.languageFrom,
    this.languageTo,
    this.newWordList,
  });

  @override
  List<Object?> get props => [languageFrom, languageTo, newWordList];
}
