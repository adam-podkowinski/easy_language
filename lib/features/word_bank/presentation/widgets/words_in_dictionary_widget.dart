import 'package:easy_language/core/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO: Show edit options and translation on right side
class WordsInDictionaryWidget extends StatelessWidget {
  const WordsInDictionaryWidget({
    Key? key,
    required this.dictionariesList,
  }) : super(key: key);

  final List<Word> dictionariesList;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: dictionariesList.length,
      onReorder: (i1, i2) {},
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(8.w),
          key: GlobalKey(),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Word: ${dictionariesList[index].wordForeign}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                subtitle: Text(
                  'Translation: ${dictionariesList[index].wordTranslation}',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.8),
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.onPrimary,
                height: 0,
              ),
            ],
          ),
        );
      },
    );
  }
}
