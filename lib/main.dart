import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/word_bank/presentation/pages/word_bank_page.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/login/presentation/pages/introduction_page.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_language/injection_container.dart' as di;
import 'package:fluttertoast/fluttertoast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(EasyLanguage());
}

// TODO: add loading screen
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
              return Container(
                color: Colors.blueAccent,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
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
    if (failure != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Error while changing settings ${failure.toString()}',
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
      );
    }
    return MaterialApp(
      title: 'Easy Language',
      themeMode: themeMode,
      theme: CustomTheme.buildLight(context),
      darkTheme: CustomTheme.buildDark(context),
      debugShowCheckedModeBanner: false,
      initialRoute: showIntroduction ? introductionPageId : wordBankPageId,
      routes: {
        wordBankPageId: (context) => const HomePage(),
        introductionPageId: (context) => const IntroductionPage(),
      },
    );
  }
}
