import 'package:easy_language/core/presentation/drawer.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/word_bank_controls.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/word_bank_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordBankPage extends StatelessWidget {
  const WordBankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = 35.r;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75.h,
          title: const Text('Word bank'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        drawer: const EasyLanguageDrawer(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: Column(
            children: [
              Center(child: WordBankControls(radius: radius)),
              SizedBox(height: 10.h),
              WordBankSheet(radius: radius),
            ],
          ),
        ),
      ),
    );
  }
}
