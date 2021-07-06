import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SettingsInitialized) {
              return _buildMaterialApp(
                context,
                state.settings.themeMode,
                state.settings.isStartup,
                failure: state.failure,
              );
            }
            return _buildMaterialApp(context, null, true);
          },
        ),
      ),
    );
  }

  Widget _buildMaterialApp(
    BuildContext context,
    ThemeMode? themeMode,
    bool showIntroduction, {
    Failure? failure,
  }) {
    return MaterialApp(
      title: 'Easy Language',
      themeMode: themeMode,
      theme: buildLight(context),
      darkTheme: buildDark(context),
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          if (failure != null) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Failure detected when saving settings!: $failure",
                    style: const TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Theme.of(context).errorColor,
                ),
              );
            });
          }
          if (showIntroduction) {
            return const SafeArea(child: IntroductionPage());
          } else {
            return OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const IntroductionPage(),
                  ),
                );
              },
              child: const Text('hello'),
            );
          }
        },
      ),
    );
  }
}
