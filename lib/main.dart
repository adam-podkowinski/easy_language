import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/main_app.dart';
import 'package:easy_language/features/login/presentation/manager/login_provider.dart';
import 'package:easy_language/features/login/presentation/pages/loading_page.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_provider.dart';
import 'package:easy_language/injection_container.dart' as di;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_games/play_games.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final SigninResult result = await PlayGames.signIn(silentSignInOnly: true);
  if (result.success) {
    await PlayGames.setPopupOptions();
  }
  runApp(EasyLanguage());
}

class EasyLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: screenSize,
      builder: () => MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsProvider>(
            create: (context) {
              final settings = di.sl<SettingsProvider>();
              settings.initSettings();
              return settings;
            },
          ),
          ChangeNotifierProvider<LoginProvider>(
            create: (context) {
              final login = di.sl<LoginProvider>();
              login.silentSignIn();
              return login;
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            final state = context.watch<SettingsProvider>();
            if (state.loading) {
              return const LoadingApp();
            } else {
              return MainApp(
                state.settings.themeMode,
                showIntroduction: state.settings.isStartup,
                failure: state.settingsFailure,
              );
            }
          },
        ),
      ),
    );
  }
}
