import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class AddWord implements Usecase<WordBank, AddWordParams> {
  final WordBankRepository repository;

  AddWord(this.repository);

  @override
  Future<Either<Failure, WordBank>> call(AddWordParams params) {
    return repository.addWord(params.language, word: params.word);
  }
}

class AddWordParams extends Equatable {
  final Language language;
  final Word word;

  const AddWordParams({required this.language, required this.word});

  @override
  List<Object?> get props => [];
}
