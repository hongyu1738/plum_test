import 'package:flutter/material.dart';
import 'package:plum_test/screens/home/home.dart';
import 'package:plum_test/screens/learn/camera.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: {
        '/camera' : (context) => Camera(),
      },
    );
  }
}