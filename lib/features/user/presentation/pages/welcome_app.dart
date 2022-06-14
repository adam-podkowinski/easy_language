import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:easy_language/features/user/presentation/pages/authenticate_page.dart';
import 'package:easy_language/features/user/presentation/pages/introduction_page.dart';
import 'package:easy_language/features/user/presentation/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class WelcomeApp extends StatelessWidget {
  const WelcomeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: Hive.openBox(cachedConfigBoxId),
      builder: (context, snapshot) {
        final bool showIntroduction = cast(snapshot.data?.get(isStartupId)) ?? true;
        return snapshot.hasData
            ? MaterialApp(
                title: 'Easy Language',
                debugShowCheckedModeBanner: false,
                theme: buildLight(context),
                darkTheme: buildDark(context),
                themeMode: UserModel.mapStringToThemeMode(
                  cast(
                    context.watch<UserProvider>().createMap[User.themeModeId],
                  ),
                ),
                home: showIntroduction
                    ? const IntroductionPage()
                    : const AuthenticatePage(),
              )
            : const LoadingApp();
      },
    );
  }
}
