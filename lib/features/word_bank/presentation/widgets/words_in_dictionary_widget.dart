import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/presentation/manager/dictionary_provider.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/show_word_dialog.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/word_bank_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';

class WordsInDictionaryWidget extends StatelessWidget {
  const WordsInDictionaryWidget({
    Key? key,
    required this.wordList,
    required this.searchController,
  }) : super(key: key);

  final List<Word> wordList;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DictionaryProvider>();

    List<Word> items = wordList;

    bool couldNotFind = false;
    bool searching = false;

    if (searchController.text != '') {
      searching = true;
      if (state.searchedWords?.isNotEmpty ?? false) {
        items = state.searchedWords!;
        couldNotFind = false;
      } else {
        couldNotFind = true;
      }
    } else {
      items = wordList;
      searching = false;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: couldNotFind
          ? Center(
              child: AutoSizeText(
                'Could not find words',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                maxLines: 1,
              ),
            )
          : ImplicitlyAnimatedList<Word>(
              items: items,
              areItemsTheSame: (a, b) => a == b,
              itemBuilder: (context, itemAnimation, item, index) {
                return WordListItem(
                  word: item,
                  itemAnimation: itemAnimation,
                  searching: searching,
                );
              },
            ),
    );
  }
}

class WordListItem extends StatelessWidget {
  const WordListItem({
    Key? key,
    required this.word,
    required this.itemAnimation,
    required this.searching,
  }) : super(key: key);

  final Word word;
  final Animation<double> itemAnimation;
  final bool searching;

  @override
  Widget build(BuildContext context) {
    final DictionaryProvider _state = context.watch<DictionaryProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizeFadeTransition(
          curve: Curves.easeInOut,
          sizeFraction: 0.7,
          animation: itemAnimation,
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.3,
              children: [
                SlidableAction(
                  label: 'Delete',
                  backgroundColor: Theme.of(context).errorColor,
                  icon: Icons.delete,
                  onPressed: (context) => _state.removeWord(
                    word,
                    searching: searching,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: ListTile(
                title: Text(
                  word.wordForeign,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                subtitle: Text(
                  word.wordTranslation,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(
                          0.8,
                        ),
                  ),
                ),
                trailing: InkWell(
                  onTap: () {
                    showWordDialog(
                      context,
                      editWordTitle,
                      (newWord) => _state.editWord(
                        word,
                        newWord,
                        searching: searching,
                      ),
                      wordToEdit: word,
                    );
                  },
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider(
          color: getSecondSheetColor(context),
          height: 1.h,
          thickness: 1.w,
        ),
      ],
    );
  }
}
