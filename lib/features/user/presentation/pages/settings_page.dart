import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/show_language_picker_dialog.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:easy_language/features/user/presentation/widgets/theme_picker.dart';
import 'package:easy_language/features/word_bank/presentation/manager/dictionary_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final login = context.watch<LoginProvider>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75.r,
          title: Text(pageTitlesFromIds[settingsPageId] ?? 'Settings'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          margin: EdgeInsets.symmetric(horizontal: 20.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30.r),
            ),
            color: Theme.of(context).colorScheme.onBackground.withOpacity(
                  0.1,
                ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              const ListTile(
                trailing: ThemePicker(),
                leading: Icon(Icons.dark_mode),
                title: Text(
                  'Theme',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              SizedBox(
                height: 10.h,
              ),
              ListTile(
                trailing: ElevatedButton(
                  onPressed: () => showLanguagePickerDialog(
                    context,
                    (Language languagePicked) {
                      context.read<UserProvider>().changeSettings(
                        {
                          User.nativeLanguageId: languagePicked.isoCode,
                        },
                      );
                    },
                    Languages.defaultLanguages,
                  ),
                  child: Text(
                    context
                        .watch<UserProvider>()
                        .settings
                        .nativeLanguage
                        .name,
                  ),
                ),
                leading: const Icon(Icons.translate),
                title: const AutoSizeText(
                  'Native Language',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              SizedBox(
                height: 10.h,
              ),
              ListTile(
                trailing: ElevatedButton(
                  onPressed:
                      context.read<DictionaryProvider>().currentDictionary == null
                          ? null
                          : () => showLanguagePickerDialog(
                                context,
                                (Language languagePicked) {
                                  context
                                      .read<DictionaryProvider>()
                                      .changeCurrentDictionary(
                                        context,
                                        languagePicked,
                                      );
                                },
                                context
                                    .read<DictionaryProvider>()
                                    .dictionaries
                                    .keys
                                    .toList(),
                              ),
                  child: Text(
                    context
                            .watch<DictionaryProvider>()
                            .currentDictionary
                            ?.language
                            .name ??
                        'None',
                    style: TextStyle(
                      color:
                          context.watch<DictionaryProvider>().currentDictionary ==
                                  null
                              ? Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5)
                              : null,
                    ),
                  ),
                ),
                leading: const Icon(Icons.translate),
                title: const AutoSizeText(
                  'Learning',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              SizedBox(
                height: 10.h,
              ),
              ListTile(
                trailing: ElevatedButton(
                  onPressed: () => showAboutDialog(
                    context: context,
                    applicationName: 'Easy Language',
                    applicationVersion: '1',
                    applicationIcon: const Icon(Icons.info),
                    applicationLegalese: '| Made by Adam Podkowinski |\n'
                        '| Open source | \n'
                        '| Source Code |\ngithub.com/adam-podkowinski/easy_language',
                  ),
                  child: const Text('About'),
                ),
                leading: const Icon(Icons.info),
                title: const Text(
                  'About app',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              SizedBox(
                height: 10.h,
              ),
              ListTile(
                trailing: ElevatedButton(
                  onPressed: null,
                  // onPressed: login.isSignedIn
                  //     ? login.signOut
                  //     : () => loginBranch(
                  //           context,
                  //           login,
                  //         ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      // login.isSignedIn ? Colors.red : Colors.green,
                      Colors.red,
                    ),
                  ),
                  // child: Text(login.isSignedIn ? 'Sign out' : 'Sign in'),
                  child: const Text('Log In'),
                ),
                leading: const Icon(Icons.login),
                title: const Text(
                  'Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
