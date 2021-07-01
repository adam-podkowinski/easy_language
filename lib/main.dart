import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EasyLanguage());
}

class EasyLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.lightGreenAccent,
        backgroundColor: Color(0xffC3DD94),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.lightGreenAccent,
        backgroundColor: Colors.black12,
        scaffoldBackgroundColor: Colors.black12,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Easy Language'),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'How are you doing!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'I bet you are doing well!',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 200,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
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
        ),
      ),
    );
  }
}
