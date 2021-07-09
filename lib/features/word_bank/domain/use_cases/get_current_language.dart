import 'package:dartz/dartz.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/use_cases/use_case.dart';
import 'package:easy_language/features/word_bank/domain/repositories/word_bank_repository.dart';
import 'package:language_picker/languages.dart';

class GetCurrentLanguage implements Usecase<Language, NoParams> {
  final WordBankRepository repository;

  GetCurrentLanguage(this.repository);

  @override
  Future<Either<Failure, Language>> call(NoParams params) async {
    return repository.getCurrentLanguge();
  }
}
