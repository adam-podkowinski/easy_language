import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/presentation/main_app.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider extends ChangeNotifier {
  bool loading = true;

  final UserRepository userRepository;

  bool get loggedIn => userRepository.loggedIn;

  User? get user => userRepository.user;

  InfoFailure? userFailure;

  Map createMap = {};

  UserProvider({
    required this.userRepository,
  });

  String get themeModeString => loggedIn
      ? UserModel.mapThemeModeToString(user?.themeMode)
      : cast(createMap[User.themeModeId]) ?? 'System';

  void _prepareMethod() {
    loading = true;
    userFailure = null;
    notifyListeners();
  }

  void _finishMethod() {
    loading = false;
    notifyListeners();
  }

  void clearError() {
    userFailure = null;
  }

  Future initUser() async {
    _prepareMethod();

    userFailure = await userRepository.initUser();

    _finishMethod();
  }

  Future editUser(Map<String, dynamic> changedSettings) async {
    _prepareMethod();

    if (!loggedIn) {
      createMap.addAll(changedSettings);
      _finishMethod();
      return;
    }

    userFailure = await userRepository.editUser(
      userMap: changedSettings,
    );

    _finishMethod();
  }

  Future googleSignIn() async {
    _prepareMethod();

    userFailure = await userRepository.googleSignIn();

    _finishMethod();
  }

  Future login(Map<String, dynamic> loginForm) async {
    _prepareMethod();

    userFailure = await userRepository.login(formMap: loginForm);

    _finishMethod();
  }

  Future register(Map<String, String> registerForm) async {
    _prepareMethod();

    final registerMap = {...registerForm, ...createMap};

    userFailure = await userRepository.register(formMap: registerMap);

    _finishMethod();
  }

  Future<bool> logout() async {
    _prepareMethod();

    userFailure = await userRepository.logout();

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      authenticatePageId,
      (_) => false,
    );

    _finishMethod();

    return userFailure == null;
  }

  Future<bool> removeAccount({
    required BuildContext context,
    String? email,
    String? password,
    bool withGoogle = false,
  }) async {
    _prepareMethod();
    if (withGoogle) {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        clientId: kIsWeb ? dotenv.env[oauthClientIdWeb] : null,
      );
      await googleSignIn.signOut();
      final GoogleSignInAccount? gAcc = await googleSignIn.signIn();
      if (gAcc == null) {
        return false;
      }
      final accToken = (await gAcc.authentication).accessToken;
      userFailure = await userRepository.removeAccount(
        email: email,
        password: password,
        googleToken: accToken,
      );
      await googleSignIn.signOut();
    } else {
      userFailure = await userRepository.removeAccount(
        email: email,
        password: password,
      );
    }

    _finishMethod();
    return userFailure == null;
  }
}
