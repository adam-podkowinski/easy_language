import 'dart:math';

import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';

class WordBankSheet extends StatelessWidget {
  const WordBankSheet({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WordBankProvider>();
    return Expanded(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryVariant,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
        ),
        child: Builder(
          builder: (context) {
            if (!state.loading) {
              if (state.wordBank.dictionaries.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add your first foreign language',
                          style: Theme.of(context).textTheme.headline6!
                            .copyWith(
                              color: CustomTheme.onBackgroundDark,
                            ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final l = Languages.defaultLanguages[Random()
                                .nextInt(Languages.defaultLanguages.length)];

                            state.addLanguageFromName(
                              l.name,
                            );
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(radius),
                              ),
                            ),
                          ),
                          child: const Text('Add new language'),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                final dictionariesList =
                    state.wordBank.dictionaries[state.currentLanguage] ?? [];
                if (dictionariesList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: dictionariesList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                dictionariesList[index].wordForeign,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                dictionariesList[index].wordTranslation,
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            Divider(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add your first word to remember it',
                            style: Theme.of(context).textTheme.headline6!
                              .copyWith(
                                color: CustomTheme.onBackgroundDark,
                              ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: show word creation picker
                              final w = Word(
                                  wordForeign:
                                      'dziena${state.wordBank.dictionaries[state.currentLanguage]?.length}',
                                  wordTranslation:
                                      'thanks${state.wordBank.dictionaries[state.currentLanguage]?.length}1');
                              state.addWordToCurrentLanguage(w);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(radius),
                                ),
                              ),
                            ),
                            child: const Text('Add new word'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
