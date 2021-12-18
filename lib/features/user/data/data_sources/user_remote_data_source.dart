
import 'package:easy_language/features/user/data/models/user_model.dart';

abstract class SettingsRemoteDataSource {
  Future<UserModel> fetchUser();

  Future<void> saveUser(UserModel settingsToCache);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  @override
  Future<UserModel> fetchUser() async {
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
    //       final Map<String, dynamic> settingsField = cast(
    //         readMap[cachedSettingsId],
    //       );
    //
    //       return SettingsModel.fromMap(settingsField);
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
  Future<void> saveUser(UserModel settingsToCache) async {
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
    //     mapToSave[cachedSettingsId] = settingsToCache.toMap();
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
