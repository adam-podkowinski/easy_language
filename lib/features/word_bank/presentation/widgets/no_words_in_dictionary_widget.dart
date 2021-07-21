import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/show_word_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoWordsInDictionaryWidget extends StatelessWidget {
  const NoWordsInDictionaryWidget({
    Key? key,
    required this.state,
    required this.radius,
  }) : super(key: key);

  final WordBankProvider state;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add your first word to remember it',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: CustomTheme.onBackgroundDark,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.h,
            ),
            ElevatedButton(
              onPressed: () {
                showWordDialog(context, state.addWordToCurrentLanguage);
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius),
                  ),
                ),
              ),
              child: const Text('Add new word'),
            ),
          ],
        ),
      ),
    );
  }
}
