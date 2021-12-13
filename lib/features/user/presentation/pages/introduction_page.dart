import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/show_language_picker_dialog.dart';
import 'package:easy_language/features/user/presentation/widgets/sign_in_button.dart';
import 'package:easy_language/features/user/domain/entities/settings.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:easy_language/features/user/presentation/widgets/theme_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserProvider>();
    return SafeArea(
      child: Scaffold(
        body: IntroductionScreen(
          pages: _buildPages(context),
          onDone: () {
            state.changeSettings({
              User.isStartupId: false,
            });
            Navigator.of(context).pushReplacementNamed(wordBankPageId);
          },
          showSkipButton: true,
          skip: const Text('Skip'),
          next: const Text('Next'),
          done: const Text('Done'),
          color: Theme.of(context).colorScheme.secondary,
          dotsDecorator: DotsDecorator(
            activeColor: Theme.of(context).colorScheme.secondary,
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
        'Native language',
        '$svgPrefix/languages.svg',
        "What language do you translate to most often?",
        footer: ElevatedButton(
          onPressed: () => showLanguagePickerDialog(
            context,
            (Language language) {
              context.read<UserProvider>().changeSettings(
                {
                  User.nativeLanguageId: language.isoCode,
                },
              );
            },
            Languages.defaultLanguages,
          ),
          child: Text(
            context.watch<UserProvider>().settings.nativeLanguage.name,
          ),
        ),
      ),
      _buildPage(
        context,
        'Save your progress',
        '$svgPrefix/learning_primary_save.svg',
        'Log in using Google Play to save your progress',
        footer: const SizedBox(
          child: SignInButton(),
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
