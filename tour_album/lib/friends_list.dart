import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:tour_album/fullscreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:tour_album/model/FriendsModel.dart';
import 'package:tour_album/friend_gallery.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'global_vars.dart' as gv;

// CODE ADAPTED FROM  https://github.com/PareshMayani/Flutter-Friends

class FriendsPage extends StatefulWidget {
  FriendsPage({Key key}) : super(key: key);

  @override
  FriendsState createState() => new FriendsState();
}

class FriendsState extends State<FriendsPage> {
  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 22.0);
  List<FriendsModel> _listFriends;

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (_isProgressBarShown) {
      widget = new Center(
          child: new Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: new CircularProgressIndicator()));
    } else {
      widget = new ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          // ignore: missing_return
          itemBuilder: (context, i) {
            //if (i.isOdd) return new Divider();
            if (i < _listFriends.length) return _buildRow(_listFriends[i]);
          });
    }

    return new Scaffold(
      appBar: _buildBar(context),
      body: widget,
    );
  }

  getFriends() async {
    final response = await FirebaseDatabase(
            databaseURL:
                'https://touralbum2-39c64-default-rtdb.europe-west1.firebasedatabase.app/')
        .reference()
        .child("users")
        .child(md5.convert(utf8.encode(gv.email)).toString())
        .child("friends")
        .once()
        .then((DataSnapshot dataSnapshot) async {
      Map newKey = dataSnapshot.value;
      List<FriendsModel> friends = [];
      for (var k in newKey.keys) {
        var name = "";
        DataSnapshot d = await FirebaseDatabase(
                databaseURL:
                    'https://touralbum2-39c64-default-rtdb.europe-west1.firebasedatabase.app/')
            .reference()
            .child("users")
            .child(k.toString())
            .once();

        final imgUrl = await FirebaseStorage.instance
            .ref()
            .child(k.toString())
            .child('profile_pic.jpg')
            .getDownloadURL();

        name = d.value["username"];

        FriendsModel f = new FriendsModel(name, k.toString(), imgUrl);
        friends.add(f);
      }
      setState(() {
        _listFriends = friends;
        print("after adding users to list");
        print(_listFriends.length);
        _isProgressBarShown = false;
      });
    });
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.black,
      title: const Text('Friends', style: TextStyle(color: Colors.blue)),
      centerTitle: true,
    );
  }

  Widget _buildRow(FriendsModel friend) {
    return FocusedMenuHolder(
      menuWidth: MediaQuery.of(context).size.width * 0.48,
      menuBoxDecoration: BoxDecoration(color: Colors.black),
      onPressed: () {},
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
            title: Text(
              "Delete",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () async {
              await FirebaseDatabase(
                      databaseURL:
                          'https://touralbum2-39c64-default-rtdb.europe-west1.firebasedatabase.app/')
                  .reference()
                  .child("users")
                  .child(md5.convert(utf8.encode(gv.email)).toString())
                  .child("friends")
                  .child(friend.email)
                  .remove()
                  .then((onValue) async {
                print('Friend deleted');
                DataSnapshot d = await FirebaseDatabase(
                        databaseURL:
                            'https://touralbum2-39c64-default-rtdb.europe-west1.firebasedatabase.app/')
                    .reference()
                    .child("users")
                    .child(md5.convert(utf8.encode(gv.email)).toString())
                    .once();
                int friends = int.parse(d.value["num_friends"].toString());

                await FirebaseDatabase(
                        databaseURL:
                            'https://touralbum2-39c64-default-rtdb.europe-west1.firebasedatabase.app/')
                    .reference()
                    .child("users")
                    .child(md5.convert(utf8.encode(gv.email)).toString())
                    .child("num_friends")
                    .set(--friends);
                setState(() {});
              });
            },
            trailingIcon: Icon(
              Icons.delete,
              color: Colors.blue,
            ),
            backgroundColor: Colors.black),
      ],
      child: Material(
        child: ListTile(
          tileColor: Colors.grey[300],
          leading: new GestureDetector(
            onTap: () {
              gv.image_url = friend.url;
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new FullScreenPage()));
            },
            child: new CircleAvatar(
              backgroundImage: friend.url == null
                  ? AssetImage('images/b.jpg')
                  : NetworkImage(friend.url),
              backgroundColor: Colors.grey,
            ),
          ),
          title: new Text(
            friend.name,
            style: _biggerFont,
          ),
          onTap: () {
            gv.friend_email = friend.email;
            gv.friend_username = friend.name;
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new FriendGallery()));
            print("friend tapped");
            setState(() {});
          },
        ),
      ),
    );
  }
}
