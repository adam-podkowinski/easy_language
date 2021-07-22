import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/show_language_picker_dialog.dart';
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
      final languagesList = state.wordBank.dictionaries.keys.toList();

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
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
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).accentColor,
              ),
            ),
            DropdownButton<Language>(
              underline: Divider(
                height: 1.w,
                color: Theme.of(context).accentColor,
              ),
              hint: const Text(addNewLanguageString),
              elevation: 0,
              value: state.currentLanguage,
              onChanged: (value) => state.changeCurrentLanguage(value),
              iconEnabledColor: Theme.of(context).accentColor,
              items: languagesList
                  .map(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Center(
                        child: Text(
                          e.name,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    } else {
      return DropdownButton(
        items: const [],
        underline: Divider(
          height: 1.w,
          color: Theme.of(context).accentColor,
        ),
        hint: const Text('Loading...'),
        elevation: 0,
      );
    }
  }
}
