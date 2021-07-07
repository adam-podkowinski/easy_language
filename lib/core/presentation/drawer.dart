import 'package:easy_language/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EasyLanguageDrawer extends StatelessWidget {
  const EasyLanguageDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello in drawer',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 10.h,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(introductionPageId);
              },
              child: const Text('Hello'),
            ),
          ],
        ),
      ),
    );
  }
}
