import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/dictionaries/presentation/manager/dictionaries_provider.dart';
import 'package:easy_language/features/dictionaries/presentation/pages/dictionaries_page.dart';
import 'package:easy_language/features/dictionaries/presentation/pages/flashcard_page.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:easy_language/features/user/presentation/pages/authenticate_page.dart';
import 'package:easy_language/features/user/presentation/pages/loading_page.dart';
import 'package:easy_language/features/user/presentation/pages/settings_page.dart';
import 'package:easy_language/features/user/presentation/pages/welcome_app.dart';
import 'package:easy_language/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// TODO: fix it when user settings change, dictionary page pops up
class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserProvider>();
    if (state.loading) {
      return const LoadingApp();
    }
    return ChangeNotifierProvider<DictionariesProvider>(
      create: (context) {
        final provider = sl<DictionariesProvider>();
        provider.initDictionaryProvider(context.read<UserProvider>().user!);
        return provider;
      },
      child: FutureBuilder<Box>(
        future: Hive.openBox(cachedConfigBoxId),
        builder: (context, _) {
          return MaterialApp(
            title: 'Easy Language',
            themeMode: state.user?.themeMode,
            theme: buildLight(context),
            darkTheme: buildDark(context),
            debugShowCheckedModeBanner: false,
            initialRoute: state.loggedIn ? dictionariesPageId : welcomePageId,
            navigatorKey: navigatorKey,
            routes: {
              dictionariesPageId: (context) => const DictionariesPage(),
              settingsPageId: (context) => const SettingsPage(),
              flashcardsPageId: (context) => const FlashcardPage(),
              authenticatePageId: (context) => const AuthenticatePage(),
              welcomePageId: (context) => const WelcomeApp(),
            },
          );
        },
      ),
    );
  }
}
