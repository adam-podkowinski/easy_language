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

    void showRemoveLanguageConfirmationDialog(BuildContext context) {
      final Widget cancelButton = OutlinedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      );
      final Widget continueButton = OutlinedButton(
        onPressed: () {
          if (state.currentLanguage != null) {
            state.removeLanguage(state.currentLanguage!);
          }
          Navigator.of(context).pop();
        },
        child: const Text('Continue'),
      );
      final AlertDialog alert = AlertDialog(
        title: const Text('Remove language?'),
        content: const Text(
          "Removing this language from your word bank can't be undone!",
        ),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

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
                  (lang) async {
                    return state.addLanguage(lang);
                  },
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
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            DropdownButton<Language>(
              underline: Divider(
                height: 1.w,
                color: Theme.of(context).colorScheme.secondary,
              ),
              hint: const Text(emptyString),
              elevation: 0,
              value: state.currentLanguage,
              onChanged: (value) => state.changeCurrentLanguage(context, value),
              iconEnabledColor: Theme.of(context).colorScheme.secondary,
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
            IconButton(
              onPressed: state.currentLanguage != null
                  ? () => showRemoveLanguageConfirmationDialog(context)
                  : null,
              icon: Icon(
                Icons.remove,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      );
    } else {
      return DropdownButton(
        items: const [],
        underline: Divider(
          height: 1.w,
          color: Theme.of(context).colorScheme.secondary,
        ),
        hint: const Text('Loading...'),
        elevation: 0,
      );
    }
  }
}
