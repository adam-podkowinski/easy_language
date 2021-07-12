import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/word_bank/presentation/manager/word_bank_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordBankControls extends StatelessWidget {
  const WordBankControls({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordBankBloc, WordBankState>(
      builder: (context, state) {
        if (state is WordBankLoaded) {
          final languagesStringList = [
            ...state.wordBank.dictionaries.keys.map((e) => e.name).toList(),
            addNewLanguageString,
          ];
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                'Currently remembering:',
                style: Theme.of(context).textTheme.subtitle1,
                maxLines: 1,
              ),
              SizedBox(width: 11.w),
              DropdownButton<String>(
                value: state.wordBank.dictionaries
                        .containsKey(state.currentLanguage)
                    ? state.currentLanguage!.name
                    : addNewLanguageString,
                onChanged: (value) {},
                iconEnabledColor: Theme.of(context).accentColor,
                items: languagesStringList
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        } else {
          return AutoSizeText(
            'Loading...',
            style: Theme.of(context).textTheme.subtitle1,
            maxLines: 1,
          );
        }
      },
    );
  }
}
