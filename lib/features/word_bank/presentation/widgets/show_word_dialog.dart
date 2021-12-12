import 'package:easy_language/core/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showWordDialog(
  BuildContext context,
  String title,
  Function(Word) onAccepted, {
  Word? wordToEdit,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return WordDialog(
        title: title,
        onAccepted: onAccepted,
        wordToEdit: wordToEdit,
      );
    },
  );
}

String? basicValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  return null;
}

class WordDialog extends StatefulWidget {
  const WordDialog({
    Key? key,
    required this.title,
    required this.onAccepted,
    this.wordToEdit,
  }) : super(key: key);

  final String title;
  final Function(Word) onAccepted;

  final Word? wordToEdit;

  @override
  _WordDialogState createState() => _WordDialogState();
}

class _WordDialogState extends State<WordDialog> {
  final _padding = 15.w;

  final _space = 20.w;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController foreignWordController;
  late final TextEditingController wordTranslationController;

  bool get edit {
    return widget.wordToEdit != null;
  }

  @override
  void initState() {
    super.initState();
    foreignWordController = TextEditingController(
      text: widget.wordToEdit?.wordForeign,
    );
    wordTranslationController = TextEditingController(
      text: widget.wordToEdit?.wordTranslation,
    );
  }

  @override
  void dispose() {
    foreignWordController.dispose();
    wordTranslationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SimpleDialog(
        title: Text(widget.title),
        contentPadding: EdgeInsets.all(_padding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_space),
        ),
        children: [
          SizedBox(
            width: 1.sw,
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: _space,
          ),
          TextFormField(
            validator: basicValidator,
            controller: foreignWordController,
            decoration: buildInputDecoration(context, 'Foreign word'),
          ),
          SizedBox(
            height: _space,
          ),
          TextFormField(
            validator: basicValidator,
            controller: wordTranslationController,
            decoration: buildInputDecoration(context, 'Word translation'),
          ),
          SizedBox(
            height: _space,
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_padding),
                ),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onAccepted(
                  Word(
                    wordForeign: foreignWordController.text.trim(),
                    wordTranslation: wordTranslationController.text.trim(),
                    updatedAt: DateTime.now(),
                    createdAt: widget.wordToEdit?.createdAt ?? DateTime.now(),
                    id: widget.wordToEdit?.id ?? 0,
                    learningStatus: widget.wordToEdit?.learningStatus ??
                        LearningStatus.reviewing,
                    dictionaryId: widget.wordToEdit?.dictionaryId ?? 0,
                    timesReviewed: widget.wordToEdit?.timesReviewed ?? 0,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Accept'),
          ),
          SizedBox(
            height: 2.h,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_padding),
                ),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_padding),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_padding),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        ),
      ),
    );
  }
}
