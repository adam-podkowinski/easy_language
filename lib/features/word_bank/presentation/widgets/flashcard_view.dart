import 'dart:async';

import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:easy_language/features/word_bank/presentation/manager/dictionary_provider.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashcardView extends StatefulWidget {
  const FlashcardView({
    Key? key,
    required this.flashcard,
    required this.state,
  }) : super(key: key);

  final Word flashcard;
  final DictionaryProvider state;

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> {
  bool available = true;
  bool isTurned = false;

  String get value => isTurned
      ? widget.flashcard.wordTranslation
      : widget.flashcard.wordForeign;

  Dictionary get currentDictionary => widget.state.currentDictionary!;

  void nextFlashcard() {
    widget.state.getNextFlashcard();

    available = false;
    isTurned = false;

    Timer(
      const Duration(seconds: 1),
      () {
        setState(() {
          available = true;
        });
      },
    );

    final newTimesReviewed = widget.flashcard.timesReviewed + 1;

    widget.state.editWord(widget.flashcard, {
      Word.timesReviewedId: newTimesReviewed,
      Word.learningStatusId: LearningStatusExtension.fromTimesReviewed(
        newTimesReviewed,
      ).statusToString,
    });
  }

  void turnFlashcard() {
    setState(() {
      isTurned = !isTurned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildWordsLearningStatus(context),
        buildFlashcardBox(context, value),
        Text(
          '${(widget.state.flashcardIndex ?? 0) + 1} '
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
          elevation: 15.sp,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          clipBehavior: Clip.hardEdge,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: isTurned
                  ? Colors.lightGreen
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(
                25.r,
              ),
            ),
            child: InkWell(
              onTap: turnFlashcard,
              child: Padding(
                padding: EdgeInsets.all(20.sp),
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
          elevation: 15.sp,
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: available
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey,
              borderRadius: BorderRadius.circular(
                25.r,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            duration: const Duration(milliseconds: 250),
            child: InkWell(
              onTap: available ? nextFlashcard : null,
              enableFeedback: false,
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
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
      transitionBuilder: (ch, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-2.5, 0),
          end: Offset.zero,
        ).animate(animation),
        child: ch,
      ),
      child: AnimatedContainer(
        height: 0.35.sh,
        margin: EdgeInsets.symmetric(horizontal: 50.sp),
        clipBehavior: Clip.hardEdge,
        curve: Curves.easeInOut,
        key: ValueKey(widget.flashcard.id),
        padding: EdgeInsets.all(12.sp),
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
          onTap: turnFlashcard,
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
                      fontSize: 32.sp,
                      letterSpacing: 1.sp,
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
          numberString: widget.state
              .getLearningLength(widget.state.currentLanguage!)
              .toString(),
          text: 'Learning',
        ),
        StatusWidget(
          color: Colors.grey,
          numberString: widget.state
              .getReviewingLength(widget.state.currentLanguage!)
              .toString(),
          text: 'Reviewing',
        ),
        StatusWidget(
          color: Theme.of(context).colorScheme.secondary,
          numberString: widget.state
              .getMasteredLength(widget.state.currentLanguage!)
              .toString(),
          text: 'Mastered',
        ),
      ],
    );
  }
}
