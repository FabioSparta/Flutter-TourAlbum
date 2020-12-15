import 'package:flutter/material.dart';

// This is the main application widget.
class GalleryTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _Gallery();
}

class _Gallery extends State<GalleryTab> {

  Widget buildPhotos(){
    return new GridView(
      scrollDirection: Axis.vertical,           //default
      reverse: false,                           //default
      controller: ScrollController(),
      primary: false,
      physics: ,
      shrinkWrap: true,
      padding: EdgeInsets.all(5.0),
      @required
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      ),        OR
      /* gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 125,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0),*/
      addAutomaticKeepAlives: true,             //default
      addRepaintBoundaries: true,               //default
      addSemanticIndexes: true,                 //default
      semanticChildCount: 0,
      cacheExtent: 0.0,
      dragStartBehavior: DragStartBehavior.start,
      clipBehavior: Clip.hardEdge,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,      
      children: []                     // List of Widgets
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            buildPhotos(),
          ],
        ),
      ),
    );
  }
}
