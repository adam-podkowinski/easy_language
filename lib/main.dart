import 'dart:io';

import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/main_app.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:easy_language/features/user/presentation/pages/loading_page.dart';
import 'package:easy_language/features/user/presentation/pages/welcome_app.dart';
import 'package:easy_language/injection_container.dart' as di;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  await dotenv.load();
  if (!kIsWeb) {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await GoogleSignInDart.register(
        clientId: dotenv.env[oauthClientIdDesktop]!,
      );
    }
  }
  runApp(EasyLanguage());
}

class EasyLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (context) {
        final user = di.sl<UserProvider>();
        SharedPreferences.getInstance().then((prefs) async {
          baseURL = prefs.getString('baseURL') ?? defaultURL;
          user.initUser();
        });
        return user;
      },
      child: ScreenUtilInit(
        designSize: screenSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_) => FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            final state = context.watch<UserProvider>();
            final SharedPreferences? prefs = snapshot.data;
            if (!snapshot.hasData) {
              return const LoadingApp();
            } else if (!state.loggedIn) {
              if (state.loading) {
                return const LoadingApp();
              }
              return WelcomeApp(
                showIntroduction: prefs?.getBool(isStartupId) ?? true,
              );
            } else {
              return MainApp(
                state.user?.themeMode,
                failure: state.userFailure,
              );
            }
          },
        ),
      ),
    );
  }
}
