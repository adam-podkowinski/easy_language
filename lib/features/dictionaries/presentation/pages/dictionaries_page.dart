import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/drawer.dart';
import 'package:easy_language/core/presentation/show_failure.dart';
import 'package:easy_language/core/presentation/show_language_picker_dialog.dart';
import 'package:easy_language/features/dictionaries/presentation/manager/dictionaries_provider.dart';
import 'package:easy_language/features/dictionaries/presentation/widgets/dictionaries_controls.dart';
import 'package:easy_language/features/dictionaries/presentation/widgets/dictionary_sheet.dart';
import 'package:easy_language/features/dictionaries/presentation/widgets/show_word_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';

class DictionariesPage extends StatefulWidget {
  const DictionariesPage({Key? key}) : super(key: key);

  @override
  _DictionariesPageState createState() => _DictionariesPageState();
}

class _DictionariesPageState extends State<DictionariesPage> {
  bool _searching = false;

  void _controllerCallback() {
    context.read<DictionariesProvider>().searchWords(
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
    return Scaffold(
      appBar: AppBar(
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
                    pageTitlesFromIds[dictionariesPageId] ?? 'Word Bank',
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
      drawer: const EasyLanguageDrawer(pageId: dictionariesPageId),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 11.sp),
        child: Column(
          children: [
            Center(child: DictionariesControls(radius: radius)),
            SizedBox(height: 10.h),
            DictionarySheet(radius: radius, controller: _controller),
          ],
        ),
      ),
    );
  }

  Widget _addWordWidget(BuildContext context) {
    final state = context.watch<DictionariesProvider>();
    showFailure(
      context,
      state.currentDictionaryFailure,
      runAfter: state.clearError,
    );
    showFailure(context, state.dictionariesFailure, runAfter: state.clearError);

    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        if (state.dictionaries.isEmpty) {
          showLanguagePickerDialog(
            context,
            (lang) async => state.addDictionary(lang),
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
            (word) => state.addWord(context, word),
          );
        }
      },
    );
  }
}
