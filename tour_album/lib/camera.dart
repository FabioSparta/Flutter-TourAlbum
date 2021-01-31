import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'global_vars.dart' as gv;
import 'package:path/path.dart' as p;

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final storageRef = FirebaseStorage.instance
      .ref()
      .child(md5.convert(utf8.encode(gv.email)).toString())
      .child('gallery');

  String firstButtonText = 'Take photo';
  String secondButtonText = 'Record video';
  String albumName = 'TourAlbum';
  String userAddress = 'Undefined';
  double textSize = 20;
  Position _position;
  StreamSubscription<Position> _streamSubscription;
  Address _address;

  @override
  void initState() {
    super.initState();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _streamSubscription = Geolocator()
        .getPositionStream(locationOptions)
        .listen((Position position) {
      setState(() {
        print(position);
        _position = position;

        final coordinates =
            new Coordinates(position.latitude, position.longitude);
        convertCoordinatesToAddress(coordinates)
            .then((value) => _address = value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //create layout for the app
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: SizedBox.expand(
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: _takePhoto,
                    child: Text(firstButtonText,
                        style:
                            TextStyle(fontSize: textSize, color: Colors.white)),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: SizedBox.expand(
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: _recordVideo,
                      child: Text(secondButtonText,
                          style: TextStyle(
                              fontSize: textSize, color: Colors.white)),
                    ),
                  )),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  //function to get the image from the camera
  void _takePhoto() async {
    // ignore: deprecated_member_use
    ImagePicker.pickImage(source: ImageSource.camera)
        .then((File recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        setState(() {
          firstButtonText = 'saving in progress...';
        });
        GallerySaver.saveImage(recordedImage.path, albumName: albumName)
            .then((bool success) async {
          //uploading image here
          await uploadImageToFirebase(recordedImage);

          print(userAddress);

          var now = DateTime.now();

          String fileName = p.basename(recordedImage.path);

          print(fileName);

          FirebaseDatabase(
                  databaseURL:
                      'https://touralbum2-39c64-default-rtdb.europe-west1.firebasedatabase.app/')
              .reference()
              .child("users")
              .child(md5.convert(utf8.encode(gv.email)).toString())
              .child("gallery")
              .child(md5.convert(utf8.encode(fileName)).toString())
              .set({
            'location': "${_address?.addressLine ?? 'undefined'}",
            'time': DateFormat('dd-MM-yyyy HH:mm:ss', 'en_US')
                .format(now)
                .toString(),
            'description': 'empty',
          }).then((onValue) {
            print('Transaction  committed.');
          }).catchError((onError) {
            print("error called " + onError.toString());
          });

          setState(() {
            firstButtonText = 'image saved! Take photo';
          });
        });
      }
    });
  }

  Future uploadImageToFirebase(File recordedImage) async {
    String fileName = p.basename(recordedImage.path);
    final storageRef = FirebaseStorage.instance
        .ref()
        .child(md5.convert(utf8.encode(gv.email)).toString())
        .child('gallery/$fileName');
    await storageRef.putFile(recordedImage);
  }

  Future<Address> convertCoordinatesToAddress(Coordinates coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  void _recordVideo() async {
    // ignore: deprecated_member_use
    ImagePicker.pickVideo(source: ImageSource.camera)
        .then((File recordedVideo) {
      if (recordedVideo != null && recordedVideo.path != null) {
        setState(() {
          secondButtonText = 'saving in progress...';
        });
        GallerySaver.saveVideo(recordedVideo.path, albumName: albumName)
            .then((bool success) {
          //videos are not being saved to firebase yet (might implement later)
          setState(() {
            secondButtonText = 'video saved! Take video';
          });
        });
      }
    });
  }
}
