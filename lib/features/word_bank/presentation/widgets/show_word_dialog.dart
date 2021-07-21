import 'package:easy_language/core/word.dart';
import 'package:flutter/material.dart';

void showWordDialog(
  BuildContext context,
  Function(Word) onAccepted,
) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: ElevatedButton(
          onPressed: () {
            onAccepted(
              const Word(wordTranslation: 'hello', wordForeign: 'siema'),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      );
    },
  );
}
