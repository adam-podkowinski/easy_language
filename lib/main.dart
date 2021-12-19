import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/main_app.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:easy_language/features/user/presentation/pages/loading_page.dart';
import 'package:easy_language/injection_container.dart' as di;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/user/presentation/pages/welcome_app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(EasyLanguage());
}

class EasyLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Debug
    SharedPreferences.setMockInitialValues({});
    return ScreenUtilInit(
      designSize: screenSize,
      builder: () => MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (context) {
              final user = di.sl<UserProvider>();
              user.initUser();
              return user;
            },
          ),
        ],
        child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            final state = context.watch<UserProvider>();
            if (!snapshot.hasData) {
              return const LoadingApp();
            } else if (!state.loggedIn) {
              final SharedPreferences? prefs = snapshot.data;
              return WelcomeApp(
                showIntroduction: prefs?.getBool(isStartupId) ?? true,
              );
            } else {
              return MainApp(
                state.user?.themeMode,
                showIntroduction: false,
                failure: state.userFailure,
              );
            }
          },
        ),
      ),
    );
  }
}
