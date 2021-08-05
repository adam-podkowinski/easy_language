import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/main_app.dart';
import 'package:easy_language/features/login/presentation/pages/loading_page.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_language/injection_container.dart' as di;
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(EasyLanguage());
}

class EasyLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: screenSize,
      builder: () => ChangeNotifierProvider(
        create: (context) {
          final settings = di.sl<SettingsProvider>();
          settings.initSettings();
          return settings;
        },
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
