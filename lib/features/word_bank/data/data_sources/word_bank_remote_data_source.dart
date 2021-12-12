import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/word_bank/data/models/word_bank_model.dart';
import 'package:language_picker/languages.dart';
import 'package:logger/logger.dart';

abstract class WordBankRemoteDataSource {
  Future<DictionariesModel> fetchWordBank();

  Future<DictionaryModel> fetchCurrentLanguage();

  Future<void> saveWordBank(DictionariesModel wordBankToCache);

  Future<void> saveCurrentDictionary(DictionaryModel dictionaryToCache);
}

class WordBankRemoteDataSourceImpl implements WordBankRemoteDataSource {
  @override
  Future<DictionaryModel> fetchCurrentLanguage() {
    // TODO: implement fetchCurrentLanguage
    throw UnimplementedError();
  }

  @override
  Future<DictionariesModel> fetchWordBank() {
    // TODO: implement fetchWordBank
    throw UnimplementedError();
  }

  @override
  Future<void> saveCurrentDictionary(DictionaryModel dictionary) {
    // TODO: implement saveCurrentLanguage
    throw UnimplementedError();
  }

  @override
  Future<void> saveWordBank(DictionariesModel wordBankToCache) {
    // TODO: implement saveWordBank
    throw UnimplementedError();
  }
  // @override
  // Future<WordBankModel> fetchWordBank() async {
  //   throw UnimplementedError();
  //   // try {
  //   //   final result = await PlayGames.getLastSignedInAccount();
  //   //   if (result.success) {
  //   //     final Snapshot save = await openSnapshot(playGamesSnapshotId);
  //   //     if (save.content == null || (save.content?.trim().isEmpty ?? true)) {
  //   //       throw RemoteException();
  //   //     } else {
  //   //       final Map<String, dynamic> readMap = cast(
  //   //         jsonDecode(save.content!),
  //   //       );
  //   //
  //   //       final Map<String, dynamic> wordBankField = cast(
  //   //         readMap[cachedWordBankId],
  //   //       );
  //   //
  //   //       return WordBankModel.fromMap(wordBankField);
  //   //     }
  //   //   } else {
  //   //     throw RemoteException();
  //   //   }
  //   // } catch (e) {
  //   //   Logger().e(e);
  //   //   throw RemoteException();
  //   // }
  // }

  // @override
  // Future<Language> fetchCurrentLanguage() async {
  //   throw UnimplementedError();
  //   // try {
  //   //   final result = await PlayGames.getLastSignedInAccount();
  //   //   if (result.success) {
  //   //     final Snapshot save = await openSnapshot(playGamesSnapshotId);
  //   //     if (save.content == null || (save.content?.trim().isEmpty ?? true)) {
  //   //       throw RemoteException();
  //   //     } else {
  //   //       final Map<String, dynamic> readMap = cast(
  //   //         jsonDecode(save.content!),
  //   //       );
  //   //
  //   //       final String currentLanguageIso = cast(
  //   //         readMap[cachedCurrentLanguageId],
  //   //       );
  //   //
  //   //       return Language.fromIsoCode(currentLanguageIso);
  //   //     }
  //   //   } else {
  //   //     throw RemoteException();
  //   //   }
  //   // } catch (e) {
  //   //   Logger().e(e);
  //   //   throw RemoteException();
  //   // }
  // }

  // @override
  // Future<void> saveWordBank(WordBankModel wordBankToCache) async {
  //   throw UnimplementedError();
  //   // try {
  //   //   final result = await PlayGames.getLastSignedInAccount();
  //   //   if (result.success) {
  //   //     Map<String, dynamic> mapToSave = {};
  //   //     final Snapshot save = await openSnapshot(playGamesSnapshotId);
  //   //     if (save.content != null &&
  //   //         (save.content?.trim().isNotEmpty ?? false)) {
  //   //       mapToSave = cast(jsonDecode(save.content!));
  //   //     }
  //   //
  //   //     mapToSave[cachedWordBankId] = wordBankToCache.toMap();
  //   //
  //   //     final bool couldSave = await PlayGames.saveSnapshot(
  //   //           'easy_language.main',
  //   //           jsonEncode(mapToSave),
  //   //         ) ??
  //   //         false;
  //   //
  //   //     if (!couldSave) {
  //   //       throw RemoteException();
  //   //     }
  //   //   } else {
  //   //     throw RemoteException();
  //   //   }
  //   // } catch (e) {
  //   //   Logger().e(e);
  //   //   throw RemoteException();
  //   // }
  // }

  // @override
  // Future<void> saveCurrentLanguage(Language languageToCache) async {
  //   throw UnimplementedError();
  //   // try {
  //   //   final result = await PlayGames.getLastSignedInAccount();
  //   //   if (result.success) {
  //   //     Map<String, dynamic> mapToSave = {};
  //   //     final Snapshot save = await openSnapshot(playGamesSnapshotId);
  //   //
  //   //     if (save.content != null &&
  //   //         (save.content?.trim().isNotEmpty ?? false)) {
  //   //       mapToSave = cast(jsonDecode(save.content!));
  //   //     }
  //   //
  //   //     mapToSave[cachedCurrentLanguageId] = languageToCache.isoCode;
  //   //
  //   //     final bool couldSave = await PlayGames.saveSnapshot(
  //   //           'easy_language.main',
  //   //           jsonEncode(mapToSave),
  //   //         ) ??
  //   //         false;
  //   //
  //   //     if (!couldSave) {
  //   //       throw RemoteException();
  //   //     }
  //   //   } else {
  //   //     throw RemoteException();
  //   //   }
  //   // } catch (e) {
  //   //   Logger().e(e);
  //   //   throw RemoteException();
  //   // }
  // }
}
