// Only async gap is loginProvider.signIn() and we are sure that
// it doesn't change the context.
//ignore_for_file: use_build_context_synchronously
import 'package:easy_language/core/util/fetch_all_remotely.dart';
import 'package:easy_language/core/util/save_all_remotely.dart';
import 'package:easy_language/features/flashcard/presentation/manager/flashcard_provider.dart';
import 'package:easy_language/features/login/presentation/manager/login_provider.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_provider.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future loginBranch(BuildContext context, LoginProvider loginProvider) async {
  final WordBankProvider wordBankProvider = context.read<WordBankProvider>();
  final FlashcardProvider flashcardProvider = context.read<FlashcardProvider>();
  final SettingsProvider settingsProvider = context.read<SettingsProvider>();

  final bool shouldFetchOrSave = await loginProvider.signIn();

  if (shouldFetchOrSave) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Found save',
            ),
            content: const Text(
              'There is data associated with your google account.'
              ' Do you want to overwrite your current progress and'
              ' load the save from your Google account or keep your local progress '
              'and lose one saved in the cloud?',
            ),
            actions: [
              OutlinedButton(
                // Fetch all data
                onPressed: () async {
                  await fetchAllRemotely(
                    wordBankProvider,
                    flashcardProvider,
                    settingsProvider,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Load save'),
              ),
              OutlinedButton(
                // Save all data
                onPressed: () async {
                  await saveAllRemotely(
                    wordBankProvider,
                    flashcardProvider,
                    settingsProvider,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Keep local progress'),
              ),
            ],
          );
        });
  } else {
    await saveAllRemotely(
      wordBankProvider,
      flashcardProvider,
      settingsProvider,
    );
  }
}
