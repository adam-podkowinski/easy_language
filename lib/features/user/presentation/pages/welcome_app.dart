import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/user/presentation/pages/authenticate_page.dart';
import 'package:easy_language/features/user/presentation/pages/introduction_page.dart';
import 'package:easy_language/features/user/presentation/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WelcomeApp extends StatelessWidget {
  const WelcomeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: Hive.openBox(cachedConfigBoxId),
      builder: (context, snapshot) {
        final bool showIntroduction =
            cast(snapshot.data?.get(isStartupId)) ?? true;
        return snapshot.hasData
            ? (showIntroduction
                ? const IntroductionPage()
                : const AuthenticatePage())
            : const LoadingApp();
      },
    );
  }
}
