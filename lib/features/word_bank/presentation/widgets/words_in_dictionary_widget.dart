import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/show_word_dialog.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/word_bank_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    final state = context.watch<WordBankProvider>();

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
          : ImplicitlyAnimatedReorderableList<Word>(
              items: items,
              areItemsTheSame: (a, b) => a == b,
              onReorderFinished: (_, __, ___, ____) {},
              // onReorderFinished: !searching
              //     ? (item, from, to, newItems) async {
              //         await state.reorderWordList(newItems);
              //       }
              //     : (_, __, ___, ____) {},
              itemBuilder: (context, itemAnimation, item, index) {
                return Reorderable(
                  key: ValueKey(item),
                  builder: (context, dragAnimation, inDrag) => WordListItem(
                    word: item,
                    index: index,
                    itemAnimation: itemAnimation,
                    searching: searching,
                  ),
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
    required this.index,
    required this.itemAnimation,
    required this.searching,
  }) : super(key: key);

  final Word word;
  final int index;
  final Animation<double> itemAnimation;
  final bool searching;

  @override
  Widget build(BuildContext context) {
    final WordBankProvider _state = context.watch<WordBankProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Handle(
          delay: const Duration(milliseconds: 150),
          child: SizeFadeTransition(
            curve: Curves.easeInOut,
            sizeFraction: 0.7,
            animation: itemAnimation,
            child: Slidable(
              actionPane: const SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Theme.of(context).errorColor,
                  icon: Icons.delete,
                  onTap: () => _state.removeWord(
                    word,
                    searching: searching,
                  ),
                ),
              ],
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
                      color:
                          Theme.of(context).colorScheme.onPrimary.withOpacity(
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
