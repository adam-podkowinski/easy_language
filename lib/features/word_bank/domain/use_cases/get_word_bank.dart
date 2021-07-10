import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/entities/word_bank.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';

class GetWordBank implements Usecase<WordBank, NoParams> {
  final WordBankRepository repository;

  GetWordBank(this.repository);

  @override
  Future<Either<Failure, WordBank>> call(NoParams params) async {
    return repository.getWordBank();
  }
}
