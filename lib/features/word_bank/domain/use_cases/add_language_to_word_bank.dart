import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class AddLanguageToWordBank
    implements Usecase<WordBank, AddLanguageToWordBankParams> {
  final WordBankRepository repository;

  AddLanguageToWordBank(this.repository);

  @override
  Future<Either<Failure, WordBank>> call(AddLanguageToWordBankParams params) {
    return repository.addLanguageToWordBank(
      params.language,
      initialWords: params.initialWords,
    );
  }
}

class AddLanguageToWordBankParams extends Equatable {
  final Language language;
  final List<Word>? initialWords;

  const AddLanguageToWordBankParams(this.language, {this.initialWords});

  @override
  List<Object?> get props => [language, initialWords];
}
