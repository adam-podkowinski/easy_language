import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/circular_progress_indicator.dart';
import 'package:easy_language/features/word_bank/presentation/manager/dictionary_provider.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/flashcard_view.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/no_flashcards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({Key? key}) : super(key: key);

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  var _init = true;

  late final DictionaryProvider state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      _init = false;
      state = context.watch<DictionaryProvider>();
      state.getCurrentFlashcard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75.h,
        title: Text(pageTitlesFromIds[flashcardsPageId] ?? 'Flashcards'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: !state.loading
            ? state.currentFlashcard != null && state.currentLanguage != null
                ? FlashcardView(
                    isTurned: state.currentFlashcard?.isTurned ?? false,
                    flashcard: state.currentFlashcard!,
                    state: state,
                  )
                : const NoFlashcards()
            : const Center(
                child: CustomCircularProgressIndicator(),
              ),
      ),
    );
  }
}
