import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.h,
          title: const Text('Languages'),
        ),
        drawer: Drawer(
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
                    Navigator.of(context).pushReplacementNamed('/introduction');
                  },
                  child: const Text('Hello'),
                ),
              ],
            ),
          ),
        ),
        body: Builder(
          builder: (context) => Stack(
            children: [
              DraggableScrollableSheet(
                minChildSize: 0.8,
                initialChildSize: 0.8,
                builder: (context, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryVariant,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                      child: ListView.builder(
                        controller: controller,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    'Lorem ipsum, $index',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    'Dolor sit amet, $index',
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
