import 'package:flutter/material.dart';
import 'package:tour_album/first_screen.dart';
import 'package:tour_album/home.dart';
import 'package:tour_album/login.dart';
import 'package:tour_album/friends_list.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'TourAlbum',
      home: Scaffold(
        body: Center(child: MyApp()),
      ),
      routes: {
        '/login': (context) => LoginPage(
              arguments: FormType.login,
              initial_type: null,
            ),
        '/home': (context) => HomePage(),
        '/first_page': (context) => FirstPage(),
        '/friends_page': (context) => FriendsPage(),
      }));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something Went Wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return new FirstPage();
        }
        return Text("loading...");
      },
    );
  }
}

enum FormType { login, register }
