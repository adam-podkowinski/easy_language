import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/dictionaries/data/models/dictionary_model.dart';
import 'package:hive/hive.dart';
import 'package:language_picker/languages.dart';
import 'package:logger/logger.dart';

abstract class DictionariesLocalDataSource {
  Future<DictionariesModel> getLocalDictionaries();

  Future cacheDictionaries(DictionariesModel dictionaries);

  void logout();
}

class DictionariesLocalDataSourceImpl implements DictionariesLocalDataSource {
  final Box dictionariesBox;

  DictionariesLocalDataSourceImpl({required this.dictionariesBox});

  @override
  void logout() {
    dictionariesBox.clear();
  }

  @override
  Future cacheDictionaries(DictionariesModel dictionariesModel) async {
    try {
      await dictionariesBox.putAll({
        'dictionaries': dictionariesModel.map(
          (key, value) => MapEntry(key.isoCode, value.toMap()),
        ),
      });
    } catch (e) {
      Logger().e(e);
      throw CacheException();
    }
  }

  @override
  Future<DictionariesModel> getLocalDictionaries() {
    try {
      if (dictionariesBox.isEmpty) {
        return Future.value({});
      }

      final Map dbMap = cast(dictionariesBox.toMap()['dictionaries']);
      final DictionariesModel dictionaries = {};
      dbMap.forEach((langIso, dictMap) {
        final lang = Language.fromIsoCode(cast(langIso));
        dictionaries[lang] = DictionaryModel.fromMap(
          cast(dictMap),
          shouldFetch: false,
        );
      });
      return Future.value(dictionaries);
    } catch (e) {
      Logger().e(e);
      throw CacheException();
    }
  }
}
