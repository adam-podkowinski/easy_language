import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/circular_progress_indicator.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/flashcard/domain/entities/flashcard.dart';
import 'package:easy_language/features/flashcard/presentation/manager/flashcard_provider.dart';
import 'package:easy_language/features/flashcard/presentation/widgets/flashcard_view.dart';
import 'package:easy_language/features/flashcard/presentation/widgets/no_flashcards.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({Key? key}) : super(key: key);

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  bool isTurned = false;
  String? value;
  Word? wordToShow;
  Flashcard? flashcard;

  var _init = true;

  late final FlashcardProvider flashcardProvider;
  late final WordBankProvider wordBankProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      flashcardProvider = context.watch<FlashcardProvider>()
        ..addListener(listenToFlashcardProvider);
      wordBankProvider = context.watch<WordBankProvider>();
      listenToFlashcardProvider();

      _init = false;
    }
  }

  @override
  void dispose() {
    flashcardProvider.removeListener(listenToFlashcardProvider);
    super.dispose();
  }

  void listenToFlashcardProvider() {
    flashcard = flashcardProvider.currentFlashcard;
    if (wordBankProvider.currentLanguage != null && flashcard != null) {
      if (wordBankProvider
              .wordBank.dictionaries[wordBankProvider.currentLanguage]!.length >
          flashcard!.wordIndex) {
        wordToShow = wordBankProvider
                .wordBank.dictionaries[wordBankProvider.currentLanguage!]
            ?[flashcard!.wordIndex];
      }
    }
    isTurned = flashcard?.isTurned ?? false;
    value = isTurned ? wordToShow?.wordTranslation : wordToShow?.wordForeign;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75.r,
          title: Text(pageTitlesFromIds[flashcardsPageId] ?? 'Flashcards'),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: !flashcardProvider.loading
              ? wordToShow != null && flashcard != null
                  ? FlashcardView(
                      isTurned: isTurned,
                      word: wordToShow!,
                      flashcard: flashcard!,
                      flashcardProvider: flashcardProvider,
                      wordBankProvider: wordBankProvider,
                    )
                  : const NoFlashcards()
              : const Center(
                  child: CustomCircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}