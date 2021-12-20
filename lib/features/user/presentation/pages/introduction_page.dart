import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/user/presentation/pages/authenticate_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: _buildPages(context),
        showDoneButton: false,
        showSkipButton: true,
        skip: const Text('Skip'),
        next: const Text('Next'),
        done: const Text('Done'),
        color: Theme.of(context).colorScheme.secondary,
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  List<PageViewModel> _buildPages(BuildContext context) {
    return [
      _buildPage(
        context,
        'Learn new languages',
        '$svgPrefix/learning_primary_first.svg',
        'Memorize new vocabulary easily with our help',
      ),
      _buildPage(
        context,
        'Minimal and simple',
        '$svgPrefix/learning_primary_clean.svg',
        'Translate new words and store them fast',
      ),
      // _buildPage(
      //   context,
      //   'Light or dark?',
      //   '$svgPrefix/dark_mode.svg',
      //   'Choose your preferable theme for this application',
      //   footer: const ThemePicker(),
      // ),
      // _buildPage(
      //   context,
      //   'Native language',
      //   '$svgPrefix/languages.svg',
      //   "What language do you translate to most often?",
      //   footer: ElevatedButton(
      //     onPressed: () => showLanguagePickerDialog(
      //       context,
      //       (Language language) {
      //         context.read<UserProvider>().editUser(
      //           {
      //             User.nativeLanguageId: language.isoCode,
      //           },
      //         );
      //       },
      //       Languages.defaultLanguages,
      //     ),
      //     child: Text(
      //       context.watch<UserProvider>().user?.nativeLanguage.name ??
      //           'no user',
      //     ),
      //   ),
      // ),
      _buildPage(
        context,
        'Log in or sign up',
        '$svgPrefix/learning_primary_save.svg',
        "It's entirely free to sign up!",
        footer: Column(
          children: [
            SizedBox(
              height: 0.05.sh,
            ),
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: Hero(
                tag: 'login',
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => const AuthenticatePage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Login',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: Hero(
                tag: 'signup',
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => const AuthenticatePage(
                          signUp: true,
                        ),
                      ),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  PageViewModel _buildPage(
    BuildContext context,
    String titleText,
    String imagePath,
    String bodyText, {
    Widget? footer,
  }) {
    return PageViewModel(
      image: Center(
        child: SvgPicture.asset(
          imagePath,
          height: 0.55.sw,
        ),
      ),
      titleWidget: AutoSizeText(
        titleText,
        maxLines: 1,
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(fontStyle: FontStyle.italic),
      ),
      body: bodyText,
      footer: footer,
    );
  }
}
