import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              final dictionariesList =
                  state.wordBank.dictionaries[state.currentLanguage] ?? [];
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
