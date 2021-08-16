import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_provider.dart';
import 'package:easy_language/features/settings/presentation/widgets/theme_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsProvider>();
    return SafeArea(
      child: Scaffold(
        body: IntroductionScreen(
          pages: _buildPages(context),
          onDone: () {
            Navigator.of(context).pushReplacementNamed(wordBankPageId).then(
                  (_) async => state.changeSettings({
                    Settings.isStartupId: false,
                  }),
                );
          },
          showSkipButton: true,
          skip: const Text('Skip'),
          next: const Text('Next'),
          done: const Text('Done'),
          color: Theme.of(context).accentColor,
          dotsDecorator: DotsDecorator(
            activeColor: Theme.of(context).accentColor,
          ),
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
      _buildPage(
        context,
        'Light or dark?',
        '$svgPrefix/dark_mode.svg',
        'Choose your preferable theme for this application',
        footer: const ThemePicker(),
      ),
      _buildPage(
        context,
        'Save your progress',
        '$svgPrefix/learning_primary_save.svg',
        'Log in using Google Play to remember your progress',
        footer: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.w),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                '$svgPrefix/google_play.svg',
                height: 40.h,
              ),
              SizedBox(
                width: 5.w,
              ),
              const Text(
                'Log in',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
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
