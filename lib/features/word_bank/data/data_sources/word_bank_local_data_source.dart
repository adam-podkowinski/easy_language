import 'dart:convert';

import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WordBankLocalDataSource {
  Future<WordBankModel> getLocalWordBank();

  Future<void> cacheWordBank(WordBankModel wordBankModel);
}

const cachedWordBankId = 'word_bank';

class WordBankLocalDataSourceImpl implements WordBankLocalDataSource {
  final SharedPreferences sharedPreferences;

  WordBankLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheWordBank(WordBankModel wordBankModel) {
    try {
      return sharedPreferences.setString(
        cachedWordBankId,
        jsonEncode(wordBankModel.toMap()),
      );
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<WordBankModel> getLocalWordBank() {
    final jsonString = sharedPreferences.getString(cachedWordBankId);
    try {
      if (jsonString != null) {
        return Future.value(
          WordBankModel.fromMap(
            jsonDecode(jsonString).cast<String, dynamic>()
                as Map<String, dynamic>,
          ),
        );
      } else {
        throw CacheException();
      }
    } on Exception {
      throw CacheException();
    }
  }
}
