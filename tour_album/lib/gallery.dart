// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'global_vars.dart' as gv;

enum GridListDemoType {
  imageOnly,
  header,
  footer,
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key key, this.type}) : super(key: key);

  final GridListDemoType type;

  @override
  Widget build(BuildContext context) {
    return createGallery(type);
  }
}

Scaffold createGallery(GridListDemoType type) {
  final storageRef = FirebaseStorage.instance
      .ref()
      .child(md5.convert(utf8.encode(gv.email)).toString())
      .child('gallery');

  return Scaffold(
    body: FutureBuilder(
        future: storageRef.listAll(),
        builder: (context, snapshot) {
          snapshot.data.items.forEach((Reference ref) {
            print('Found file: $ref');
          });

          //NetworkImage(url)

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
                      print(snap.data.toString());
                      return _GridDemoPhotoItem(
                        url: snap.data,
                        tileStyle: type,
                      );
                    });
              }).toList(),
            ),
          );
        }),
  );
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

class _GridDemoPhotoItem extends StatelessWidget {
  _GridDemoPhotoItem({
    Key key,
    @required this.url,
    @required this.tileStyle,
  }) : super(key: key);

  String url;
  GridListDemoType tileStyle;

  @override
  Widget build(BuildContext context) {
    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
    tileStyle = GridListDemoType.footer;
    switch (tileStyle) {
      case GridListDemoType.imageOnly:
        return image;
      case GridListDemoType.header:
        return GridTile(
          header: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
              title: _GridTitleText("title"),
              backgroundColor: Colors.black45,
            ),
          ),
          child: image,
        );
      case GridListDemoType.footer:
        return GridTile(
          footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
              backgroundColor: Colors.black45,
              title: _GridTitleText("title"),
              subtitle: _GridTitleText("subtitle/description"),
            ),
          ),
          child: image,
        );
    }
    return null;
  }
}
