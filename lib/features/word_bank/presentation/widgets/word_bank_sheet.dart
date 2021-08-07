import 'package:easy_language/core/presentation/circular_progress_indicator.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/no_languages_widget.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/no_words_in_dictionary_widget.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/words_in_dictionary_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Color getSheetColor(BuildContext context) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;

  if (isDark) {
    return Theme.of(context).colorScheme.primaryVariant;
  } else {
    return Theme.of(context).colorScheme.primary;
  }
}

Color getSecondSheetColor(BuildContext context) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;

  if (!isDark) {
    return Theme.of(context).colorScheme.primaryVariant;
  } else {
    return Theme.of(context).colorScheme.primary;
  }
}

class WordBankSheet extends StatefulWidget {
  const WordBankSheet({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  _WordBankSheetState createState() => _WordBankSheetState();
}

class _WordBankSheetState extends State<WordBankSheet> {
  late final WordBankProvider state;
  Widget currentWidget = const Center(
    child: CustomCircularProgressIndicator(),
  );
  bool init = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      state = context.watch<WordBankProvider>();
      state.addListener(_changeCurrentWidget);
      init = false;
    }
  }

  @override
  void dispose() {
    state.removeListener(_changeCurrentWidget);
    super.dispose();
  }

  void _changeCurrentWidget() {
    if (!state.loading) {
      if (state.wordBank.dictionaries.isEmpty) {
        currentWidget = NoLanguagesWidget(
          state: state,
          radius: widget.radius,
        );
      } else {
        final dictionary =
            state.wordBank.dictionaries[state.currentLanguage] ?? [];
        if (dictionary.isNotEmpty) {
          currentWidget = WordsInDictionaryWidget(
            wordList: dictionary,
          );
        } else {
          currentWidget = NoWordsInDictionaryWidget(
            state: state,
            radius: widget.radius,
          );
        }
      }
    } else {
      currentWidget = const Center(
        child: CustomCircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              getSheetColor(context),
              getSheetColor(context),
              getSecondSheetColor(context),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.radius),
            topRight: Radius.circular(widget.radius),
          ),
        ),
        child: Builder(
          builder: (context) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.decelerate,
              switchOutCurve: Curves.decelerate,
              child: currentWidget,
            );
          },
        ),
      ),
    );
  }
}
