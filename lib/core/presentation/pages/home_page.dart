import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Center(
            child: Text(
              'Hello in drawer',
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
        ),
        body: Builder(
          builder: (context) => Stack(
            children: [
              Positioned(
                top: 25.h,
                left: 25.w,
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hello in home page!',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed('/introduction'),
                      child: const Text('Hello'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}