import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';

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
      itemBuilder: (lang) => Text('${lang.name} (${lang.isoCode})'),
      isSearchable: true,
      onValuePicked: onValuePicked,
      isDividerEnabled: true,
      divider: Divider(
        height: 0,
        color: Theme.of(context).primaryColor,
      ),
      languages: languages,
    ),
  );
}
