import 'package:easy_language/core/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordsInDictionaryWidget extends StatelessWidget {
  const WordsInDictionaryWidget({
    Key? key,
    required this.dictionariesList,
  }) : super(key: key);

  final List<Word> dictionariesList;

  @override
  Widget build(BuildContext context) {
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
  }
}
