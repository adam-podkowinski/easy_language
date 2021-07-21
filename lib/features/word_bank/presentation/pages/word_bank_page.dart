import 'dart:math';

import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/presentation/drawer.dart';
import 'package:easy_language/core/presentation/show_error.dart';
import 'package:easy_language/core/presentation/show_language_picker_dialog.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/show_word_dialog.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/word_bank_controls.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/word_bank_sheet.dart';
import 'package:easy_language/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';

class WordBankPage extends StatelessWidget {
  const WordBankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = 35.r;
    return SafeArea(
      child: ChangeNotifierProvider<WordBankProvider>(
        create: (context) {
          final provider = sl<WordBankProvider>();
          provider.initWordBank();
          return provider;
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 75.h,
            title: const Text('Word bank'),
            actions: [
              Builder(
                builder: (context) {
                  return _addWordWidget(context);
                },
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
      ),
    );
  }

  Widget _addWordWidget(BuildContext context) {
    final state = context.watch<WordBankProvider>();
    if (state.currentLanguageFailure is LanguageCacheFailure) {
      showError(context, state.currentLanguageFailure.toString());
    }
    if (state.wordBankFailure is WordBankCacheFailure) {
      showError(context, state.wordBankFailure.toString());
    }
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        if (state.wordBank.dictionaries.isEmpty) {
          showLanguagePickerDialog(
            context,
            (lang) async => state.addLanguage(lang),
            Languages.defaultLanguages
                .where(
                  (element) =>
                      !state.wordBank.dictionaries.keys.contains(element),
                )
                .toList(),
          );
        } else {
          showWordDialog(
              context, addNewWordTitle, state.addWordToCurrentLanguage);
        }
      },
    );
  }
}
