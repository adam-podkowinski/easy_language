import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/main_page.dart';
import 'package:easy_language/features/login/presentation/pages/loading_page.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_language/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(EasyLanguage());
}

class EasyLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsBloc = di.sl<SingletonSettingsBloc>();
    return ScreenUtilInit(
      designSize: screenSize,
      builder: () => BlocProvider(
        create: (context) => settingsBloc,
        child: BlocBuilder<SingletonSettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsInitial) {
              settingsBloc.add(
                const GetSettingsEvent(),
              );
              return const LoadingApp();
            } else if (state is SettingsInitialized) {
              return MainApp(
                state.settings.themeMode,
                showIntroduction: state.settings.isStartup,
                failure: state.failure,
              );
            }
            return const MainApp(null, showIntroduction: true);
          },
        ),
      ),
    );
  }
}
