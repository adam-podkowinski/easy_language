import 'package:easy_language/core/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashcardsPage extends StatelessWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75.r,
          title: Text(pageTitlesFromIds[flashcardsPageId] ?? 'Flashcards'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatusWidget(
                  color: Theme.of(context).primaryColor,
                  numberString: '3',
                  text: 'Learning',
                ),
                const StatusWidget(
                  color: Colors.grey,
                  numberString: '4',
                  text: 'Reviewing',
                ),
                StatusWidget(
                  color: Theme.of(context).accentColor,
                  numberString: '10',
                  text: 'Mastered',
                ),
              ],
            ),
            Container(
              height: 0.35.sh,
              margin: EdgeInsets.symmetric(horizontal: 50.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryVariant,
                    Theme.of(context).colorScheme.primaryVariant,
                    Theme.of(context).colorScheme.primaryVariant,
                    Theme.of(context).primaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  'institute',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 30,
                        letterSpacing: 1,
                      ),
                ),
              ),
            ),
            Card(
              color: Theme.of(context).accentColor,
              elevation: 15.r,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({
    Key? key,
    required this.text,
    required this.numberString,
    required this.color,
  }) : super(key: key);

  final String text;
  final String numberString;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 13.r,
          height: 13.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(
          height: 9.h,
        ),
        Text(
          numberString,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
