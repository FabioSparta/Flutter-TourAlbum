// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'package:tour_album/fullscreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'global_vars.dart' as gv;

enum GridListDemoType {
  imageOnly,
  header,
  footer,
}

class FriendGallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _FriendGallery();
}

class _FriendGallery extends State<FriendGallery> {
  _FriendGallery({this.type});

  final GridListDemoType type;

  final storageRef =
      FirebaseStorage.instance.ref().child(gv.friend_email).child('gallery');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: FutureBuilder(
          future: storageRef.listAll(),
          builder: (context, snapshot) {
            snapshot.data.items.forEach((Reference ref) {
              print('Found file: $ref');
            });

            return Scaffold(
              body: GridView.count(
                restorationId: 'grid_view_demo_grid_offset',
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                padding: const EdgeInsets.all(8),
                childAspectRatio: 1,
                children: snapshot.data.items.map<Widget>((photo) {
                  return FutureBuilder(
                      future: photo.getDownloadURL(),
                      builder: (context2, snap) {
                        print("URL!!!!: " + snap.data);
                        return GridDemoPhotoItem(
                          w: this,
                          url: snap.data,
                          tileStyle: type,
                          imgRef: photo.fullPath,
                        );
                      });
                }).toList(),
              ),
            );
          }),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.black,
      title: Text(gv.friend_username + "'s gallery",
          style: TextStyle(color: Colors.blue)),
      centerTitle: true,
    );
  }
}

/// Allow the text size to shrink to fit in the space
class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Text(text),
    );
  }
}

class GridDemoPhotoItem extends StatefulWidget {
  GridDemoPhotoItem({
    @required this.w,
    @required this.url,
    @required this.tileStyle,
    @required this.imgRef,
  });

  String url;
  GridListDemoType tileStyle;
  String imgRef;
  var w;

  @override
  State<StatefulWidget> createState() => new _GridDemoPhotoItem();
}

class _GridDemoPhotoItem extends State<GridDemoPhotoItem> {
  @override
  Widget build(BuildContext context) {
    var img = this.widget.imgRef.split('/').last;

    var fbDB = FirebaseDatabase(
            databaseURL:
                'https://touralbum2-39c64-default-rtdb.europe-west1.firebasedatabase.app/')
        .reference()
        .child("users")
        .child(gv.friend_email)
        .child("gallery")
        .child(md5.convert(utf8.encode(img)).toString());

    return GestureDetector(
      onTap: () {
        gv.image_url = this.widget.url;
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new FullScreenPage()));
      },
      child: GridTile(
        footer: Material(
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
          ),
          clipBehavior: Clip.antiAlias,
          child: StreamBuilder(
              stream: fbDB.onValue,
              builder: (context, snap) {
                return GridTileBar(
                  backgroundColor: Colors.black45,
                  title: _GridTitleText(snap.data.snapshot.value["time"]),
                  subtitle:
                      _GridTitleText(snap.data.snapshot.value["location"]),
                );
              }),
        ),
        child: GestureDetector(
          child: FocusedMenuHolder(
            menuWidth: MediaQuery.of(context).size.width * 0.48,
            menuBoxDecoration: BoxDecoration(color: Colors.black),
            onPressed: () {},
            menuItems: <FocusedMenuItem>[
              FocusedMenuItem(
                  title: Text(
                    "Open",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    print("clicked open full screen");
                    gv.image_url = this.widget.url;
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new FullScreenPage()));
                  },
                  trailingIcon: Icon(
                    Icons.aspect_ratio,
                    color: Colors.blue,
                  ),
                  backgroundColor: Colors.black),
              FocusedMenuItem(
                  title: Text(
                    "Edit Description",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {},
                  trailingIcon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  backgroundColor: Colors.black),
              FocusedMenuItem(
                  title: Text(
                    "Delete",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    FirebaseStorage.instance.ref(this.widget.imgRef).delete();
                    fbDB.remove().then((onValue) {
                      print('Photo deleted');
                      this.widget.w.setState(() {});
                    });
                  },
                  trailingIcon: Icon(
                    Icons.delete,
                    color: Colors.blue,
                  ),
                  backgroundColor: Colors.black),
            ],
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(this.widget.url),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
