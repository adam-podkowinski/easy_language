import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/flashcard/data/models/flashcard_model.dart';
import 'package:logger/logger.dart';

abstract class FlashcardRemoteDataSource {
  Future<FlashcardModel> fetchFlashcard();

  Future<void> saveFlashcard(FlashcardModel flashcardToCache);
}

class FlashcardRemoteDataSourceImpl implements FlashcardRemoteDataSource {
  @override
  Future<FlashcardModel> fetchFlashcard() async {
    throw UnimplementedError();
    // try {
    //   final result = await PlayGames.getLastSignedInAccount();
    //   if (result.success) {
    //     final Snapshot save = await openSnapshot(playGamesSnapshotId);
    //     if (save.content == null || (save.content?.trim().isEmpty ?? true)) {
    //       throw RemoteException();
    //     } else {
    //       final Map<String, dynamic> readMap = cast(
    //         jsonDecode(save.content!),
    //       );
    //
    //       final Map<String, dynamic> flashcardField = cast(
    //         readMap[cachedCurrentFlashcardId],
    //       );
    //
    //       return FlashcardModel.fromMap(flashcardField);
    //     }
    //   } else {
    //     throw RemoteException();
    //   }
    // } catch (e) {
    //   Logger().e(e);
    //   throw RemoteException();
    // }
  }

  @override
  Future<void> saveFlashcard(FlashcardModel flashcardToCache) async {
    throw UnimplementedError();
    // try {
    //   final result = await PlayGames.getLastSignedInAccount();
    //   if (result.success) {
    //     Map<String, dynamic> mapToSave = {};
    //     final Snapshot save = await openSnapshot(playGamesSnapshotId);
    //
    //     if (save.content != null &&
    //         (save.content?.trim().isNotEmpty ?? false)) {
    //       mapToSave = cast(jsonDecode(save.content!));
    //     }
    //
    //     mapToSave[cachedCurrentFlashcardId] = flashcardToCache.toMap();
    //
    //     final bool couldSave = await PlayGames.saveSnapshot(
    //           'easy_language.main',
    //           jsonEncode(mapToSave),
    //         ) ??
    //         false;
    //
    //     if (!couldSave) {
    //       throw RemoteException();
    //     }
    //   } else {
    //     throw RemoteException();
    //   }
    // } catch (e) {
    //   Logger().e(e);
    //   throw RemoteException();
    // }
  }
}
