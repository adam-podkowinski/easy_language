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
  }) : super(key: key);

  final List<Word> wordList;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WordBankProvider>();
    return ImplicitlyAnimatedReorderableList<Word>(
      items: wordList,
      areItemsTheSame: (a, b) => a == b,
      onReorderFinished: (item, from, to, newItems) async {
        await state.reorderWordList(newItems);
      },
      itemBuilder: (context, itemAnimation, item, index) {
        return Reorderable(
          key: ValueKey(item),
          builder: (context, dragAnimation, inDrag) => WordListItem(
            word: item,
            index: index,
            itemAnimation: itemAnimation,
          ),
        );
      },
    );
  }
}

class WordListItem extends StatelessWidget {
  const WordListItem({
    Key? key,
    required this.word,
    required this.index,
    required this.itemAnimation,
  }) : super(key: key);

  final Word word;
  final int index;
  final Animation<double> itemAnimation;

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
                  onTap: () => _state.removeWord(index),
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
                          index,
                          newWord,
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
