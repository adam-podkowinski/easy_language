import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/presentation/drawer.dart';
import 'package:easy_language/core/presentation/show_error.dart';
import 'package:easy_language/core/presentation/show_language_picker_dialog.dart';
import 'package:easy_language/features/word_bank/presentation/manager/dictionary_provider.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/show_word_dialog.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/word_bank_controls.dart';
import 'package:easy_language/features/word_bank/presentation/widgets/word_bank_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';

class WordBankPage extends StatefulWidget {
  const WordBankPage({Key? key}) : super(key: key);

  @override
  _WordBankPageState createState() => _WordBankPageState();
}

class _WordBankPageState extends State<WordBankPage> {
  bool _searching = false;

  void _controllerCallback() {
    context.read<DictionaryProvider>().searchWords(
          _controller.text,
        );
  }

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_controllerCallback);
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerCallback);
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = 30.r;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75.r,
          title: AnimatedSwitcher(
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            child: _searching
                ? TextFormField(
                    controller: _controller,
                    focusNode: _focus,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      fillColor: Theme.of(context).colorScheme.secondary,
                      focusColor: Theme.of(context).colorScheme.secondary,
                      hoverColor: Theme.of(context).colorScheme.secondary,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      pageTitlesFromIds[wordBankPageId] ?? 'Word Bank',
                    ),
                  ),
          ),
          actions: [
            Builder(
              builder: (context) {
                return _addWordWidget(context);
              },
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _searching
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          _focus.unfocus();
                          _searching = false;
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _searching = true;
                          _focus.requestFocus();
                        });
                      },
                    ),
            ),
          ],
        ),
        drawer: const EasyLanguageDrawer(pageId: wordBankPageId),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: Column(
            children: [
              Center(child: WordBankControls(radius: radius)),
              SizedBox(height: 10.h),
              WordBankSheet(radius: radius, controller: _controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addWordWidget(BuildContext context) {
    final state = context.watch<DictionaryProvider>();
    if (state.currentDictionaryFailure is DictionaryCacheFailure) {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        showError(context, state.currentDictionaryFailure.toString());
        state.clearError();
      });
    }
    if (state.dictionariesFailure is DictionariesCacheFailure) {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        showError(context, state.dictionariesFailure.toString());
        state.clearError();
      });
    }
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        if (state.dictionaries.isEmpty) {
          showLanguagePickerDialog(
            context,
            (lang) async => state.addLanguage(lang),
            Languages.defaultLanguages
                .where(
                  (element) => !state.dictionaries.keys.contains(element),
                )
                .toList(),
          );
        } else {
          showWordDialog(
            context,
            addNewWordTitle,
            (word) async => state.addWord(context, word),
          );
        }
      },
    );
  }
}
