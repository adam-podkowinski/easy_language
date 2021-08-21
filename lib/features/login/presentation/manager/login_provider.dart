import 'package:flutter/cupertino.dart';
import 'package:play_games/play_games.dart';

class LoginProvider extends ChangeNotifier {
  SigninResult? signInResult;

  bool get isSignedIn {
    return (signInResult?.success) ?? false;
  }

  Future silentSignIn() async {
    signInResult = await PlayGames.signIn(
      scopeSnapshot: true,
      silentSignInOnly: true,
    );
    notifyListeners();
  }

  Future signIn() async {
    signInResult = await PlayGames.signIn(scopeSnapshot: true);
    notifyListeners();
  }

  Future signOut() async {
    await PlayGames.signOut();
    signInResult = null;
    notifyListeners();
  }
}
