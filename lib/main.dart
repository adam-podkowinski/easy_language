import 'package:flutter/material.dart';

void main() {
  runApp(EasyLanguage());
}

class EasyLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple,
        accentColor: Colors.lightGreenAccent,
        backgroundColor: Color(0xffC3DD94),
      ),
      darkTheme: Theme.of(context).copyWith(backgroundColor: Colors.black87),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Easy Language'),
        ),
        body: Container(
          color: Color(0xffC3DD94),
          child: Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Hello'),
            ),
          ),
        ),
      ),
    );
  }
}
