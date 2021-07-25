import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/word.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_provider.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/show_word_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return AnimatedList(
      key: state.wordListKey,
      initialItemCount: wordList.length,
      itemBuilder: (context, index, anim) {
        final Word word = wordList[index];
        return WordListItem(
          word: word,
          state: state,
          index: index,
          anim: anim,
        );
      },
    );
  }
}

class WordListItem extends StatefulWidget {
  const WordListItem({
    Key? key,
    required this.word,
    required this.state,
    required this.index,
    required this.anim,
  }) : super(key: key);

  final Word word;
  final WordBankProvider state;
  final int index;
  final Animation anim;

  @override
  _WordListItemState createState() => _WordListItemState();
}

class _WordListItemState extends State<WordListItem> {
  final _offsetAnim = Tween<Offset>(
    begin: const Offset(
      1.5,
      0.0,
    ),
    end: Offset.zero,
  );

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.anim.drive(_offsetAnim),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        key: GlobalKey(),
        child: Column(
          children: [
            ListTile(
              onTap: () {},
              title: Text(
                'Word: ${widget.word.wordForeign}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              subtitle: Text(
                'Translation: ${widget.word.wordTranslation}',
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      showWordDialog(
                        context,
                        editWordTitle,
                        (newWord) => widget.state.changeWord(
                          widget.index,
                          newWord,
                        ),
                        wordToEdit: widget.word,
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                    onTap: () {
                      widget.state.removeWord(widget.index);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.onPrimary,
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}
