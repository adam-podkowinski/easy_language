import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:hive/hive.dart';

abstract class WordBankLocalDataSource {
  Future<WordBankModel> getLocalWordBank();

  Future<void> cacheWordBank(WordBankModel wordBankModel);
}

class WordBankLocalDataSourceImpl implements WordBankLocalDataSource {
  final Box wordBankBox;

  WordBankLocalDataSourceImpl({required this.wordBankBox});

  @override
  Future<void> cacheWordBank(WordBankModel wordBankModel) async {
    try {
      await wordBankBox.putAll(wordBankModel.toMap());
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<WordBankModel> getLocalWordBank() {
    try {
      if (wordBankBox.isEmpty) {
        throw CacheException();
      } else {
        final dbMap = wordBankBox.toMap();
        return Future.value(WordBankModel.fromMap(dbMap));
      }
    } on Exception {
      throw CacheException();
    }
  }
}
