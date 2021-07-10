import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class ChangeCurrentLanguage
    implements Usecase<Language, ChangeCurrentLanguageParams> {
  final WordBankRepository repository;

  ChangeCurrentLanguage(this.repository);

  @override
  Future<Either<Failure, Language>> call(ChangeCurrentLanguageParams params) {
    return repository.changeCurrentLanguage(params.language);
  }
}

class ChangeCurrentLanguageParams extends Equatable {
  final Language language;

  const ChangeCurrentLanguageParams({required this.language});

  @override
  List<Object?> get props => [language];
}
