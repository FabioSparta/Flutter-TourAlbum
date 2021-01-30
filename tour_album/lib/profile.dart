import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'global_vars.dart' as gv;
import 'package:tour_album/friends_list.dart';
import 'package:tour_album/first_screen.dart';

import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return CreateProfile(context, screenSize);
  }
}

Scaffold CreateProfile(BuildContext context, Size screenSize) {
  final storageRef = FirebaseStorage.instance
      .ref()
      .child(md5.convert(utf8.encode(gv.email)).toString())
      .child('profile_pic.jpg');

  final dbRef = FirebaseDatabase(
          databaseURL:
              'https://touralbum2-39c64-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child("users")
      .child(md5.convert(utf8.encode(gv.email)).toString());

  return Scaffold(
    body: StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, snap) {
          Map data = snap.data.snapshot.value;
          final String _status = "User Status";
          final String _locations = "...";
          final String _achievements = "...";

          return FutureBuilder(
              future: storageRef.getDownloadURL(),
              builder: (context, snapshot) {
                return Stack(
                  children: <Widget>[
                    _buildCoverImage(screenSize),
                    SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: screenSize.height / 6),
                            _buildProfileImage(
                                snapshot.data), //using Storage for image
                            _buildFullName(data['username']),
                            _buildStatus(context, _status),
                            _buildStatContainer(
                                _achievements,
                                data['num_friends'].toString(),
                                _locations,
                                context),
                            _buildBio(context),
                            _buildSeparator(screenSize),
                            SizedBox(height: 10.0),
                            _buildChangedPicture(context),
                            SizedBox(height: 8.0),
                            _buildButtons(context),
                            SizedBox(height: 8.0),
                            _buildLogout(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              });
        }),
  );
}

Widget _buildCoverImage(Size screenSize) {
  return Container(
    height: screenSize.height / 3.5,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/a.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _buildProfileImage(url) {
  return Center(
    child: Container(
      width: 140.0,
      height: 140.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: url == null ? AssetImage('images/b.jpg') : NetworkImage(url),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(80.0),
        border: Border.all(
          color: Colors.white,
          width: 10.0,
        ),
      ),
    ),
  );
}

Widget _buildFullName(String name) {
  TextStyle _nameTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
  );

  return Text(
    name,
    style: _nameTextStyle,
  );
}

Widget _buildStatus(BuildContext context, String _status) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(4.0),
    ),
    child: Text(
      _status,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}

Widget _buildStatItem(String label, String count, context) {
  TextStyle _statLabelTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w200,
  );

  TextStyle _statCountTextStyle = TextStyle(
    color: Colors.black54,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        count,
        style: _statCountTextStyle,
      ),
      new GestureDetector(
        onTap: () {
          if (label == "Friends") {
            print("friends Clicked");
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new FriendsPage())
          ) ;
          }
        },
        child: new Text(
          label,
          style: _statLabelTextStyle,
        ),
      )
    ],
  );
}

Widget _buildStatContainer(
    String _achievements, String _noFriends, String _locations, context) {
  return Container(
    height: 60.0,
    margin: EdgeInsets.only(top: 8.0),
    decoration: BoxDecoration(
      color: Color(0xFFEFF4F7),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildStatItem("Achievements", _achievements, context),
        _buildStatItem("Friends", _noFriends, context),
        _buildStatItem("Visited Locations", _locations, context),
      ],
    ),
  );
}

Widget _buildBio(BuildContext context) {
  TextStyle bioTextStyle = TextStyle(
    fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
    fontStyle: FontStyle.italic,
    color: Color(0xFF799497),
    fontSize: 16.0,
  );

  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    padding: EdgeInsets.all(8.0),
  );
}

Widget _buildSeparator(Size screenSize) {
  return Container(
    width: screenSize.width / 1.6,
    height: 2.0,
    color: Colors.black54,
    margin: EdgeInsets.only(top: 4.0),
  );
}

Widget _buildChangedPicture(BuildContext context) {
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Expanded(
      child: InkWell(
        onTap: () => print("followed"),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(),
            color: Color(0xFF404A5C),
          ),
          child: Center(
            child: Text(
              "Change Picture",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildLogout(BuildContext context) {
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Expanded(
      child: InkWell(
        onTap: () => _logout(context),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(),
            color: Color(0xFF404A5C),
          ),
          child: Center(
            child: Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildButtons(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () async {
              Uint8List result =
                  await scanner.generateBarCode("Sou eu o Gervaldo");
              await showDialog(context: context, builder: (_) => ImageDialog());
            },
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                border: Border.all(),
                color: Color(0xFF404A5C),
              ),
              child: Center(
                child: Text(
                  "QR Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: InkWell(
            onTap: () async {
              String cameraScanResult = await scanner.scan();
            },
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Add Friend",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/*https://medium.com/codechai/uploading-image-to-firebase-storage-in-flutter-app-android-ios-31ddd66843fc
//upload new user profile picture
Future changeImage(storageRef) async {
  await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
    StorageUploadTask uploadTask = storageRef.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageRef.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  });
}
*/
_logout(context) async {
  await FirebaseAuth.instance.signOut();
  print("logout");
   Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new FirstPage())
          ) ;
}

enum FormType { login, register }

class ImageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/tamas.jpg'), fit: BoxFit.cover)),
      ),
    );
  }
}
