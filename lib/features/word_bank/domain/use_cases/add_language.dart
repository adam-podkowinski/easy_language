import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class AddLanguage implements Usecase<WordBank, AddLanguageParams> {
  final WordBankRepository repository;

  AddLanguage(this.repository);

  @override
  Future<Either<Failure, WordBank>> call(AddLanguageParams params) {
    return repository.addLanguage(params.language);
  }
}

class AddLanguageParams extends Equatable {
  final Language language;
  final List<Word>? initialWords;

  const AddLanguageParams(this.language, {this.initialWords});

  @override
  List<Object?> get props => [language, initialWords];
}
