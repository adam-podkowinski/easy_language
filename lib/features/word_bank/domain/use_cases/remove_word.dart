import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class RemoveWord implements Usecase<WordBank, RemoveWordParams> {
  final WordBankRepository repository;

  RemoveWord(this.repository);

  @override
  Future<Either<Failure, WordBank>> call(RemoveWordParams params) {
    return repository.removeWord(params.language, index: params.index);
  }
}

class RemoveWordParams extends Equatable {
  final Language language;
  final int index;

  const RemoveWordParams({required this.language, required this.index});

  @override
  List<Object?> get props => [];
}
