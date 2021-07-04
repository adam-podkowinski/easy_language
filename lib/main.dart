import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/view/styles.dart';
import 'package:easy_language/features/login/presentation/pages/introduction_page.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_bloc.dart';
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
    return ScreenUtilInit(
      designSize: screenSize,
      builder: () => BlocProvider(
        create: (context) => di.sl<SettingsBloc>(),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsInitial) {
              BlocProvider.of<SettingsBloc>(context).add(
                const GetSettingsEvent(),
              );
              return const CircularProgressIndicator();
            } else if (state is SettingsInitialized) {
              return MaterialApp(
                title: 'Easy Language',
                themeMode: state.settings.themeMode,
                theme: buildLight(context),
                darkTheme: buildDark(context),
                debugShowCheckedModeBanner: false,
                home: const SafeArea(child: IntroductionPage()),
              );
            }
            return MaterialApp(
              title: 'Easy Language',
              theme: buildLight(context),
              darkTheme: buildDark(context),
              debugShowCheckedModeBanner: false,
              home: const SafeArea(child: IntroductionPage()),
            );
          },
        ),
      ),
    );
  }
}
