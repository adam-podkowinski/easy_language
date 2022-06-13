import 'dart:io';

import 'package:dartz/dartz.dart';
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
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

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
        Hive.openBox(cachedConfigBoxId).then((box) async {
          baseURL = cast(box.get(baseURLId)) ?? defaultURL;
          user.initUser();
        });
        return user;
      },
      child: ScreenUtilInit(
        designSize: screenSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => FutureBuilder<Box>(
          future: Hive.openBox(cachedConfigBoxId),
          builder: (context, snapshot) {
            final state = context.watch<UserProvider>();
            if (!snapshot.hasData) {
              return const LoadingApp();
            }
            final Box box = snapshot.data!;

            if (state.loggedIn) {
              return MainApp(
                state.user?.themeMode,
                failure: state.userFailure,
              );
            }

            if (state.loading) {
              return const LoadingApp();
            }

            return WelcomeApp(
              showIntroduction: cast(box.get(isStartupId)) ?? true,
            );
          },
        ),
      ),
    );
  }
}
