import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/word_bank/presentation/manager/dictionary_provider.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/show_word_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoWordsInDictionaryWidget extends StatelessWidget {
  const NoWordsInDictionaryWidget({
    Key? key,
    required this.state,
    required this.radius,
  }) : super(key: key);

  final DictionaryProvider state;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add your first word to remember it',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: onBackgroundDark,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 18.h,
            ),
            ElevatedButton(
              onPressed: () {
                showWordDialog(
                  context,
                  addNewWordTitle,
                  (word) => state.addWord(context, word),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: const Text(
                  'Add new word',
                  style: TextStyle(
                    fontSize: 16,
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
