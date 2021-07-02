import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/view/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(EasyLanguage());
}

class EasyLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: SCREEN_SIZE,
      builder: () => MaterialApp(
        title: 'Easy Language',
        themeMode: ThemeMode.light,
        theme: buildLight(context),
        darkTheme: buildDark(context),
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Easy Language',
            ),
            centerTitle: true,
            foregroundColor: Colors.white,
          ),
          body: Builder(
            builder: (context) {
              print('Width: ${MediaQuery.of(context).size.width}');
              print('Height: ${MediaQuery.of(context).size.height}');
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'How are you doing!',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'I bet you are doing well!',
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Container(
                        width: 200.w,
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                            ),
                          ),
                          child: Text(
                            'Hello',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
