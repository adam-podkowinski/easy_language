import 'package:easy_language/core/presentation/show_language_picker_dialog.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/dictionaries/presentation/manager/dictionaries_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language_picker/languages.dart';

class NoLanguagesWidget extends StatelessWidget {
  const NoLanguagesWidget({
    Key? key,
    required this.state,
    required this.radius,
  }) : super(key: key);

  final DictionariesProvider state;
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
              'Add your first foreign language',
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
                showLanguagePickerDialog(
                  context,
                  (lang) async {
                    return state.addDictionary(lang);
                  },
                  Languages.defaultLanguages
                      .where(
                        (element) => !state.dictionaries.keys.contains(element),
                      )
                      .toList(),
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
                padding: EdgeInsets.all(5.sp),
                child: Text(
                  'Add new language',
                  style: TextStyle(
                    fontSize: 15.sp,
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
