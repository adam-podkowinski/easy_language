import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/drawer.dart';
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
          toolbarHeight: 75.h,
          title: Text(pageTitlesFromIds[flashcardsPageId] ?? 'Flashcards'),
        ),
        drawer: const EasyLanguageDrawer(pageId: flashcardsPageId),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: Center(
            child: Text(
              'hello',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      ),
    );
  }
}
