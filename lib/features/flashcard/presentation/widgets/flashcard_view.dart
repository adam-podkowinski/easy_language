import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/flashcard/domain/entities/flashcard.dart';
import 'package:easy_language/features/flashcard/presentation/manager/flashcard_provider.dart';
import 'package:easy_language/features/flashcard/presentation/widgets/status_widget.dart';
import 'package:easy_language/features/word_bank/presentation/manager/dictionary_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashcardView extends StatelessWidget {
  const FlashcardView({
    Key? key,
    required this.isTurned,
    required this.word,
    required this.flashcard,
    required this.flashcardProvider,
    required this.dictionaryProvider,
  }) : super(key: key);

  final bool isTurned;
  final Word word;
  final Flashcard flashcard;
  final FlashcardProvider flashcardProvider;
  final DictionaryProvider dictionaryProvider;

  void nextFlashcard() {
    flashcardProvider.getNextFlashcard(
      dictionaryProvider.currentDictionary,
    );

    final newTimesReviewed = word.timesReviewed + 1;

    dictionaryProvider.editWord(
      word,
      word.copyWithMap({
        Word.timesReviewedId: newTimesReviewed,
        Word.learningStatusId: LearningStatusExtension.fromTimesReviewed(
          newTimesReviewed,
        ).statusToString,
      }).toMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final value = isTurned ? word.wordTranslation : word.wordForeign;
    final currentDictionary = dictionaryProvider.currentDictionary!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildWordsLearningStatus(context),
        buildFlashcardBox(context, value),
        Text(
          '${flashcard.wordIndex + 1} '
          '/ '
          '${currentDictionary.words.length}',
          style: Theme.of(context).textTheme.headline3,
        ),
        buildFlashcardControls(context),
      ],
    );
  }

  Row buildFlashcardControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: isTurned
              ? Colors.lightGreen
              : Theme.of(context).colorScheme.secondary,
          elevation: 15.r,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () async {
              await flashcardProvider.turnCurrentFlashcard();
            },
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Icon(
                  isTurned ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
        Card(
          color: Theme.of(context).colorScheme.secondary,
          elevation: 15.r,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: nextFlashcard,
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  AnimatedSwitcher buildFlashcardBox(BuildContext context, String value) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (ch, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-2.5, 0),
            end: Offset.zero,
          ).animate(animation),
          child: ch,
        );
      },
      child: AnimatedContainer(
        height: 0.35.sh,
        margin: EdgeInsets.symmetric(horizontal: 50.w),
        clipBehavior: Clip.hardEdge,
        curve: Curves.easeInOut,
        key: ValueKey(word),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          gradient: LinearGradient(
            colors: isTurned
                ? [
                    Theme.of(context).primaryColor,
                    Theme.of(context).colorScheme.primaryVariant,
                  ]
                : [
                    Theme.of(context).colorScheme.primaryVariant,
                    Theme.of(context).primaryColor,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        duration: const Duration(milliseconds: 400),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () async {
            await flashcardProvider.turnCurrentFlashcard();
          },
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (
                Widget child,
                Animation<double> animation,
              ) {
                return FadeTransition(
                  opacity: Tween<double>(
                    begin: 0,
                    end: 1,
                  ).animate(animation),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-2, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                value,
                key: ValueKey<String>(value),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 30,
                      letterSpacing: 1,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildWordsLearningStatus(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatusWidget(
          color: Theme.of(context).primaryColor,
          numberString: dictionaryProvider
              .getLearningLength(flashcard.wordLanguage)
              .toString(),
          text: 'Learning',
        ),
        StatusWidget(
          color: Colors.grey,
          numberString: dictionaryProvider
              .getReviewingLength(flashcard.wordLanguage)
              .toString(),
          text: 'Reviewing',
        ),
        StatusWidget(
          color: Theme.of(context).colorScheme.secondary,
          numberString: dictionaryProvider
              .getMasteredLength(flashcard.wordLanguage)
              .toString(),
          text: 'Mastered',
        ),
      ],
    );
  }
}
