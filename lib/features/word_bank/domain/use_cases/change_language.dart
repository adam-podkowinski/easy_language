import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class ChangeLanguage implements Usecase<WordBank, ChangeLanguageParams> {
  final WordBankRepository repository;

  ChangeLanguage(this.repository);

  @override
  Future<Either<Failure, WordBank>> call(ChangeLanguageParams params) {
    return repository.changeLanguage(
      languageFrom: params.languageFrom,
      languageTo: params.languageTo,
    );
  }
}

class ChangeLanguageParams extends Equatable {
  final Language languageFrom;
  final Language languageTo;

  const ChangeLanguageParams({
    required this.languageFrom,
    required this.languageTo,
  });

  @override
  List<Object?> get props => [languageFrom, languageTo];
}
