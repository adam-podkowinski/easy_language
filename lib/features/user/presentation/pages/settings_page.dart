import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/show_language_picker_dialog.dart';
import 'package:easy_language/features/dictionaries/presentation/manager/dictionaries_provider.dart';
import 'package:easy_language/features/dictionaries/presentation/widgets/remove_account_dialog.dart';
import 'package:easy_language/features/dictionaries/presentation/widgets/remove_account_with_google_dialog.dart';
import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:easy_language/features/user/presentation/widgets/logout_button.dart';
import 'package:easy_language/features/user/presentation/widgets/theme_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController apiController = TextEditingController(
      text: baseURL,
    );

    final DictionariesProvider dictionaryState =
        context.watch<DictionariesProvider>();
    final UserProvider userState = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitlesFromIds[settingsPageId] ?? 'Settings'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.r),
        margin: EdgeInsets.symmetric(horizontal: 20.r),
        clipBehavior: Clip.antiAlias,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.r),
          ),
          color: Theme.of(context).colorScheme.onBackground.withOpacity(
                0.1,
              ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 1.w),
            child: Column(
              children: [
                const ListTile(
                  trailing: ThemePicker(),
                  leading: Icon(Icons.dark_mode),
                  title: Text(
                    'Theme',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  thickness: 1.h,
                ),
                ListTile(
                  trailing: ElevatedButton(
                    onPressed: () => showLanguagePickerDialog(
                      context,
                      (Language languagePicked) {
                        userState.editUser(
                          {
                            User.nativeLanguageId: languagePicked.isoCode,
                          },
                        );
                      },
                      Languages.defaultLanguages,
                    ),
                    child: Text(
                      userState.user?.nativeLanguage.name ?? 'no user',
                    ),
                  ),
                  leading: const Icon(Icons.translate),
                  title: const AutoSizeText(
                    'Native Language',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  thickness: 1.h,
                ),
                ListTile(
                  trailing: ElevatedButton(
                    onPressed: dictionaryState.currentLanguage == null
                        ? null
                        : () => showLanguagePickerDialog(
                              context,
                              (Language languagePicked) {
                                dictionaryState.changeCurrentDictionary(
                                  context,
                                  languagePicked,
                                );
                              },
                              dictionaryState.dictionaries.keys.toList(),
                            ),
                    child: Text(
                      dictionaryState.currentLanguage?.name ?? 'None',
                      style: TextStyle(
                        color: dictionaryState.currentLanguage == null
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
                Divider(
                  thickness: 1.h,
                  color: Theme.of(context).primaryColor,
                ),
                ListTile(
                  trailing: ElevatedButton(
                    onPressed: () => showAboutDialog(
                      context: context,
                      applicationName: 'Easy Language',
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
                Divider(
                  thickness: 1.h,
                  color: Theme.of(context).primaryColor,
                ),
                const ListTile(
                  trailing: LogoutButton(),
                  leading: Icon(Icons.login),
                  title: Text(
                    'Account',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  thickness: 1.h,
                  color: Theme.of(context).primaryColor,
                ),
                ListTile(
                  trailing: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            userState.user?.isRegisteredWithGoogle ?? false
                                ? const RemoveAccountWithGoogleDialog()
                                : const RemoveAccountDialog(),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: const Text('Delete account'),
                  ),
                  leading: const Icon(
                    Icons.login,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Remove account',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.h,
                  color: Theme.of(context).primaryColor,
                ),
                if (kDebugMode)
                  ListTile(
                    trailing: IntrinsicWidth(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.done),
                            onPressed: () async {
                              if (apiController.value.text.isEmpty) {
                                baseURL = defaultURL;
                              } else {
                                baseURL = apiController.value.text;
                              }

                              final box = await Hive.openBox(cachedConfigBoxId);
                              box.put('baseURL', baseURL);
                            },
                          ),
                          SizedBox(
                            width: 0.25.sw,
                            child: TextFormField(
                              controller: apiController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    leading: const Icon(Icons.api),
                    title: const Text(
                      'API address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                if (kDebugMode)
                  Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 1.h,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
