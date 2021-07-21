import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';

// TODO: more rounded corners in language dialog

void showLanguagePickerDialog(
  BuildContext context,
  Function(Language) onValuePicked,
  List<Language> languages,
) {
  showDialog(
    context: context,
    builder: (context) => LanguagePickerDialog(
      title: const AutoSizeText(
        'Choose a language',
        maxLines: 1,
      ),
      itemBuilder: (lang) => AutoSizeText(
        '${lang.name} (${lang.isoCode})',
        maxLines: 1,
      ),
      isSearchable: true,
      onValuePicked: onValuePicked,
      titlePadding: EdgeInsets.only(bottom: 15.h),
      isDividerEnabled: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 5.w,
        vertical: 15.h,
      ),
      searchInputDecoration: InputDecoration(
        hintText: 'Search...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.w),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      divider: Divider(
        height: 0,
        color: Theme.of(context).primaryColor,
      ),
      languages: languages,
    ),
  );
}
