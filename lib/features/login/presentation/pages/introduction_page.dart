import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroductionPage extends StatelessWidget {
  static const SVG_PREFIX = 'assets/svgs';

  IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: _buildPages(context),
        onDone: () {},
        showDoneButton: true,
        showNextButton: true,
        showSkipButton: true,
        color: Theme.of(context).primaryColor,
        skip: Text('Skip'),
        next: Text('Next'),
        done: Text('Done'),
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  List<PageViewModel> _buildPages(BuildContext context) {
    return [
      _buildPage(
        context,
        'Learn new languages',
        '$SVG_PREFIX/learning_primary_first.svg',
        'Memorize new vocabulary easily with our help',
      ),
      _buildPage(
        context,
        'Minimal and simple',
        '$SVG_PREFIX/learning_primary_clean.svg',
        'Translate new words and store them fast',
      ),
      _buildPage(
        context,
        'Save your progress',
        '$SVG_PREFIX/learning_primary_save.svg',
        'Log in using Google Play to remember your progress',
        footer: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.green,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.w
                ),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: SvgPicture.asset(
              '$SVG_PREFIX/google_play.svg',
              width: 125.w,
              allowDrawingOutsideViewBox: true,
            ),
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
        style: Theme.of(context).textTheme.headline5,
      ),
      body: bodyText,
      footer: footer,
    );
  }
}
