import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/circular_progress_indicator.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/flashcard/domain/entities/flashcard.dart';
import 'package:easy_language/features/flashcard/presentation/manager/flashcard_provider.dart';
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
              ? value != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatusWidget(
                              color: Theme.of(context).primaryColor,
                              numberString: '3',
                              text: 'Learning',
                            ),
                            const StatusWidget(
                              color: Colors.grey,
                              numberString: '4',
                              text: 'Reviewing',
                            ),
                            StatusWidget(
                              color: Theme.of(context).accentColor,
                              numberString: '10',
                              text: 'Mastered',
                            ),
                          ],
                        ),
                        AnimatedContainer(
                          height: 0.35.sh,
                          margin: EdgeInsets.symmetric(horizontal: 50.w),
                          clipBehavior: Clip.hardEdge,
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            gradient: LinearGradient(
                              colors: isTurned
                                  ? [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                    ]
                                  : [
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
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
                              await context
                                  .read<FlashcardProvider>()
                                  .turnCurrentFlashcard();
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
                                        begin: const Offset(-2, 0.0),
                                        end: const Offset(0.0, 0.0),
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Text(
                                  value!,
                                  key: ValueKey<String>(value!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 30,
                                        letterSpacing: 1,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              color: isTurned
                                  ? Colors.lightGreen
                                  : Theme.of(context).accentColor,
                              elevation: 15.r,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                onTap: () async {
                                  await flashcardProvider
                                      .turnCurrentFlashcard();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(20.r),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: Icon(
                                      isTurned
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Card(
                              color: Theme.of(context).accentColor,
                              elevation: 15.r,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                onTap: () async {
                                  await flashcardProvider.getNextFlashcard(
                                    wordBankProvider.wordBank,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(20.r),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not enough words to use flashcards',
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: const Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
              : const Center(
                  child: CustomCircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({
    Key? key,
    required this.text,
    required this.numberString,
    required this.color,
  }) : super(key: key);

  final String text;
  final String numberString;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 13.r,
          height: 13.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(
          height: 9.h,
        ),
        Text(
          numberString,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
