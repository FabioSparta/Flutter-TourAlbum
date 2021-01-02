import 'package:flutter/material.dart';

import 'package:tour_album/camera.dart';
import 'package:tour_album/gallery.dart';
import 'package:tour_album/map.dart';
import 'package:tour_album/google_map.dart';
import 'package:tour_album/profile.dart';

import 'gallery.dart';

// This is the main application widget.
class HomePage extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 3;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Tour Album', style: TextStyle(color: Colors.blue)),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          CameraScreen(),
          GoogleMapScreen(),
          GalleryPage(),
          UserProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[700],
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_alt_outlined,
              color: Colors.blue,
            ),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              color: Colors.blue,
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_outlined,
              color: Colors.blue,
            ),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: Colors.blue,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
