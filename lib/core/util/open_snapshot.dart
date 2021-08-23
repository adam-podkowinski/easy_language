import 'package:easy_language/core/error/exceptions.dart';
import 'package:play_games/play_games.dart';

import '../constants.dart';

Future<Snapshot> openSnapshot(String name) async {
  try {
    final Snapshot save = await PlayGames.openSnapshot(playGamesSnapshotId);
    if (save.content == null || (save.content?.trim().isEmpty ?? true)) {
      throw RemoteException();
    } else {
      return save;
    }
  } catch (e) {
    if (e is CloudSaveConflictError) {
      return resolveConflict(e);
    } else {
      throw RemoteException();
    }
  }
}

Future<Snapshot> resolveConflict(CloudSaveConflictError e) async {
  try {
    final snapshot = await PlayGames.resolveSnapshotConflict(
      playGamesSnapshotId,
      e.conflictId ?? '',
      e.local.content ?? '',
    );
    return snapshot;
  } catch (e) {
    if (e is CloudSaveConflictError) {
      return resolveConflict(e);
    } else {
      throw RemoteException();
    }
  }
}
