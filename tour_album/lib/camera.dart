import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:crypto/crypto.dart';
import 'global_vars.dart' as gv;

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
  double textSize = 20;

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
            .then((bool success) {
          //implement here the upload
          setState(() {
            firstButtonText = 'image saved! Take photo';
          });
        });
      }
    });
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
          setState(() {
            secondButtonText = 'video saved! Take video';
          });
        });
      }
    });
  }
}
