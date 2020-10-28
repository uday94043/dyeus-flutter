import 'package:flutter/material.dart';
import 'PlayerScreen.dart';
import 'Constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: colorCustom
      ),
      home: PlayerScreen(),
    );
  }
}

