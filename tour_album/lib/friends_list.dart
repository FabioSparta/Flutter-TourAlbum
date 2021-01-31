import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:tour_album/model/FriendsModel.dart';
import 'package:tour_album/friend_gallery.dart';
import 'global_vars.dart' as gv;

// CODE ADAPTED FROM  https://github.com/PareshMayani/Flutter-Friends

class FriendsPage extends StatefulWidget {
  FriendsPage({Key key}) : super(key: key);

  @override
  FriendsState createState() => new FriendsState();
}

class FriendsState extends State<FriendsPage> {
  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<FriendsModel> _listFriends;

  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
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
      //TODO: search how to stop ListView going infinite list
      widget = new ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
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

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.black,
      title: const Text('Friends', style: TextStyle(color: Colors.blue)),
      centerTitle: true,
    );
  }

  Widget _buildRow(FriendsModel friendsModel) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: Colors.grey,
        // backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
      ),
      title: new Text(
        friendsModel.name,
        style: _biggerFont,
      ),
      subtitle: new Text(friendsModel.email),
      onTap: () {
        gv.friend_email = friendsModel.email;
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new FriendGallery()));
        print("friend tapped");
        setState(() {});
      },
    );
  }

  _fetchFriendsList() async {
    _isProgressBarShown = true;
    List<FriendsModel> listFriends = new List<FriendsModel>();

    //EXAMPLE OF A FRIEND 1 //////////////////////////
    String name = "first_name" + " " + "last_name";

    // var objImage = res['picture'];
    //String profileUrl = objImage['large'].toString();
    FriendsModel friendsModel =
        new FriendsModel(name, "email"); //, profileUrl);

    listFriends.add(friendsModel);
    //print(friendsModel.profileImageUrl);
    ////////////////////////////////////////////////////

    //EXAMPLE OF A FRIEND 2 //////////////////////////////
    name = "first_name2" + " " + "last_name2";

    // var objImage = res['picture'];
    //String profileUrl = objImage['large'].toString();
    FriendsModel friendsModel2 =
        new FriendsModel(name, "email2"); //, profileUrl);

    listFriends.add(friendsModel2);
    //print(friendsModel.profileImageUrl);
    ///////////////////////////////////////////////////

    if (!mounted) return;
    setState(() {
      _listFriends = listFriends;
      print("after adding users to list");
      print(_listFriends.length);
      _isProgressBarShown = false;
    });
  }
}
