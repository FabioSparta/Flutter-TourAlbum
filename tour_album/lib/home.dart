import 'package:flutter/material.dart';
import 'package:tour_album/gallery.dart';

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
  int _selectedIndex = 0;
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
        backgroundColor: Colors.blue,
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          Text(
            'Index 0: Map',
            style: optionStyle,
          ),
          GalleryPage(),
          Text(
            'Index 2: Profile',
            style: optionStyle,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[700],
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
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
