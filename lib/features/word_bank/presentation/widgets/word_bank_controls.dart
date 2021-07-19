import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';

class WordBankControls extends StatelessWidget {
  const WordBankControls({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WordBankProvider>();
    if (!state.loading) {
      final languagesStringList = [
        ...state.wordBank.dictionaries.keys.map((e) => e.name).toList(),
        addNewLanguageString,
      ];
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: DropdownButton<String>(
          underline: Divider(
            height: 1.w,
            color: Theme.of(context).accentColor,
          ),
          hint: const Text(addNewLanguageString),
          elevation: 0,
          value: state.currentLanguage?.name,
          onChanged: (value) {
            if (value == addNewLanguageString) {
              // TODO: show a language picker
              final l = Languages.defaultLanguages[
                  Random().nextInt(Languages.defaultLanguages.length)];

              state.addLanguageFromName(l.name);
            } else {
              state.changeCurrentLanguageFromName(value);
            }
          },
          iconEnabledColor: Theme.of(context).accentColor,
          items: languagesStringList
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Center(
                    child: Text(
                      e,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    } else {
      return AutoSizeText(
        'Loading...',
        style: Theme.of(context).textTheme.subtitle1,
        maxLines: 1,
      );
    }
  }
}
