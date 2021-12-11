import 'package:easy_language/core/constants.dart';
import 'package:flutter/cupertino.dart';

class LoginProvider extends ChangeNotifier {
  // SigninResult? signInResult;
  //
  // bool get isSignedIn {
  //   return (signInResult?.success) ?? false;
  // }
  //
  // Future silentSignIn() async {
  //   signInResult = await PlayGames.signIn(
  //     scopeSnapshot: true,
  //     silentSignInOnly: true,
  //   );
  //   if (signInResult?.success ?? false) {
  //     PlayGames.setPopupOptions();
  //   }
  //   notifyListeners();
  // }

  /// Returns [true] when there is data to fetch (should call [fetchAllRemotely]).
  /// Returns [false] when there is no data to fetch (should call [saveAllRemotely]).
  // Future<bool> signIn() async {
  //   try {
  //     signInResult = await PlayGames.signIn(scopeSnapshot: true);
  //     if (signInResult?.success ?? false) {
  //       await PlayGames.setPopupOptions();
  //     }
  //     notifyListeners();
  //     final snapshot = await openSnapshot(playGamesSnapshotId);
  //     if (snapshot.content != null ||
  //         (snapshot.content?.trim().isNotEmpty ?? false)) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (_) {
  //     notifyListeners();
  //     return false;
  //   }
  // }
  //
  // Future signOut() async {
  //   await PlayGames.signOut();
  //   signInResult = null;
  //   notifyListeners();
  // }
}
