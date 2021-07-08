import 'package:easy_language/core/presentation/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingApp extends StatelessWidget {
  const LoadingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Language',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: CustomTheme.primaryVariant,
        body: Center(
          child: Text(
            'Easy Language',
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: 'Mulish',
            ),
          ),
        ),
      ),
    );
  }
}
