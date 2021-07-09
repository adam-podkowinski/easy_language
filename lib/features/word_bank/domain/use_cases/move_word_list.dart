import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class MoveWordList implements Usecase<WordBank, MoveWordListParams> {
  final WordBankRepository repository;

  MoveWordList(this.repository);

  @override
  Future<Either<Failure, WordBank>> call(MoveWordListParams params) {
    return repository.moveWordList(
      params.language,
      newWordList: params.newWordList,
    );
  }
}

class MoveWordListParams extends Equatable {
  final Language language;
  final List<Word> newWordList;

  const MoveWordListParams({required this.language, required this.newWordList});

  @override
  List<Object?> get props => [];
}
