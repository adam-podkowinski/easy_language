import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/dictionaries/presentation/manager/dictionary_provider.dart';
import 'package:easy_language/features/dictionaries/presentation/widgets/flashcard_view.dart';
import 'package:easy_language/features/dictionaries/presentation/widgets/no_flashcards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({Key? key}) : super(key: key);

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  var _init = true;

  late final DictionariesProvider state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      _init = false;
      state = context.watch<DictionariesProvider>();
      state.getCurrentFlashcard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitlesFromIds[flashcardsPageId] ?? 'Flashcards'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: state.currentFlashcard != null && state.currentLanguage != null
            ? FlashcardView(
                flashcard: state.currentFlashcard!,
                state: state,
              )
            : const NoFlashcards(),
      ),
    );
  }
}
