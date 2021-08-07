import 'package:easy_language/core/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  _FlashcardsPageState createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  bool isTurned = false;
  String value = 'institute';

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
            AnimatedContainer(
              height: 0.35.sh,
              margin: EdgeInsets.symmetric(horizontal: 50.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                gradient: LinearGradient(
                  colors: isTurned
                      ? [
                          Theme.of(context).primaryColor,
                          Theme.of(context).colorScheme.primaryVariant,
                        ]
                      : [
                          Theme.of(context).colorScheme.primaryVariant,
                          Theme.of(context).primaryColor,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              duration: const Duration(milliseconds: 400),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isTurned = !isTurned;
                    value = isTurned ? 'akcja' : 'institute';
                  });
                },
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-2, 0.0),
                            end: const Offset(0.0, 0.0),
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      value,
                      key: ValueKey<String>(value),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 30,
                            letterSpacing: 1,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: isTurned
                      ? Colors.lightGreen
                      : Theme.of(context).accentColor,
                  elevation: 15.r,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isTurned = !isTurned;
                        value = isTurned ? 'akcja' : 'institute';
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(20.r),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Icon(
                          isTurned ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Card(
                  color: Theme.of(context).accentColor,
                  elevation: 15.r,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
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
