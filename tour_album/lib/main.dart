import 'package:flutter/material.dart';
import 'package:tour_album/home.dart';
import 'package:tour_album/login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Tour Album',
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: new LoginPage(),
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
        });
  }
}
