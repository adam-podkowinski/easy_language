import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/core/util/open_snapshot.dart';
import 'package:easy_language/features/settings/data/models/settings_model.dart';
import 'package:logger/logger.dart';
import 'package:play_games/play_games.dart';

abstract class SettingsRemoteDataSource {
  Future<SettingsModel> fetchSettings();

  Future<void> saveSettings(SettingsModel settingsToCache);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  @override
  Future<SettingsModel> fetchSettings() async {
    try {
      final result = await PlayGames.getLastSignedInAccount();
      if (result.success) {
        final Snapshot save = await openSnapshot(playGamesSnapshotId);
        if (save.content == null || (save.content?.trim().isEmpty ?? true)) {
          throw RemoteException();
        } else {
          final Map<String, dynamic> readMap = cast(
            jsonDecode(save.content!),
          );

          final Map<String, dynamic> settingsField = cast(
            readMap[cachedSettingsId],
          );

          return SettingsModel.fromMap(settingsField);
        }
      } else {
        throw RemoteException();
      }
    } catch (e) {
      Logger().e(e);
      throw RemoteException();
    }
  }

  @override
  Future<void> saveSettings(SettingsModel settingsToCache) async {
    try {
      final result = await PlayGames.getLastSignedInAccount();
      if (result.success) {
        Map<String, dynamic> mapToSave = {};
        final Snapshot save = await openSnapshot(playGamesSnapshotId);

        if (save.content != null &&
            (save.content?.trim().isNotEmpty ?? false)) {
          mapToSave = cast(jsonDecode(save.content!));
        }

        mapToSave[cachedSettingsId] = settingsToCache.toMap();

        final bool couldSave = await PlayGames.saveSnapshot(
              'easy_language.main',
              jsonEncode(mapToSave),
            ) ??
            false;

        if (!couldSave) {
          throw RemoteException();
        }
      } else {
        throw RemoteException();
      }
    } catch (e) {
      Logger().e(e);
      throw RemoteException();
    }
  }
}
