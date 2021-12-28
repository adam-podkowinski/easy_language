import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_language/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EasyLanguageDrawer extends StatelessWidget {
  const EasyLanguageDrawer({
    Key? key,
    required this.pageId,
  }) : super(key: key);

  final String pageId;

  @override
  Widget build(BuildContext context) {
    final double listSpacing = 14.w;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 0.5.sw),
        child: Drawer(
          elevation: 0,
          child: ListView(
            padding: EdgeInsets.all(40.sp),
            children: [
              Text(
                pageTitlesFromIds[pageId] ?? 'Word Bank',
                style: Theme.of(context).textTheme.headline6,
              ),
              Divider(
                height: 70.h,
                thickness: 1,
                color: Theme.of(context).primaryColor,
              ),
              DrawerListTile(
                name: 'Word list',
                isFocused: pageId == wordBankPageId,
                leadingIconData: Icons.list,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(wordBankPageId);
                },
              ),
              SizedBox(
                height: listSpacing,
              ),
              DrawerListTile(
                name: 'Flashcards',
                isFocused: pageId == flashcardsPageId,
                leadingIconData: Icons.dynamic_feed,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(flashcardsPageId);
                },
              ),
              SizedBox(
                height: listSpacing,
              ),
              DrawerListTile(
                name: 'Settings',
                isFocused: pageId == settingsPageId,
                leadingIconData: Icons.settings,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(settingsPageId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.name,
    required this.onTap,
    required this.leadingIconData,
    this.isFocused = false,
  }) : super(key: key);

  /// Name of a tile
  final String name;

  /// If the settings is in this screen highlight this tile
  final bool isFocused;

  /// If tile is pressed invoke this function
  final Function() onTap;

  /// Icon data that is shown before name
  final IconData leadingIconData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: AutoSizeText(
          name,
          maxLines: 1,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w700,
                color:
                    isFocused ? Theme.of(context).colorScheme.onPrimary : null,
              ),
        ),
      ),
      leading: Icon(
        leadingIconData,
        color: isFocused
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onBackground,
      ),
      tileColor:
          isFocused ? Theme.of(context).primaryColor : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.sp),
      ),
      onTap: isFocused ? null : onTap,
    );
  }
}
