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
    return Drawer(
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.all(40.w),
        children: [
          Text(
            'Word Bank',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 40.h,
          ),
          DrawerListTile(
            name: 'Word list',
            isFocused: pageId == wordBankPageId,
            onTap: () => Navigator.of(context).pushReplacementNamed(
              wordBankPageId,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          DrawerListTile(
            name: 'Flashcards',
            isFocused: pageId == flashcardsPageId,
            onTap: () => Navigator.of(context).pushReplacementNamed(
              flashcardsPageId,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          DrawerListTile(
            name: 'Settings',
            isFocused: pageId == introductionPageId,
            onTap: () => Navigator.of(context).pushReplacementNamed(
              introductionPageId,
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: add a trailing svg image
class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.name,
    required this.onTap,
    this.isFocused = false,
  }) : super(key: key);

  /// Name of a tile
  final String name;

  /// If the user is in this screen highlight this tile
  final bool isFocused;

  /// If tile is pressed invoke this function
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          color: isFocused ? Theme.of(context).colorScheme.onPrimary : null,
        ),
      ),
      tileColor:
          isFocused ? Theme.of(context).primaryColor : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.w),
      ),
      onTap: onTap,
    );
  }
}
