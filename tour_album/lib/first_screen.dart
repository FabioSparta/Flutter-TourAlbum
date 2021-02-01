import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FirstPageContent();
}

class FirstPageContent extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    askPermissions();
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.1, 0.3, 1],
            colors: [Colors.deepPurple, Colors.purple, Colors.blue]),
      ),
      child: new ListView(
        children: <Widget>[buildTitle(), buildButtons(context)],
      ),
    ));
  }

  Widget buildTitle() {
    return new Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.1),
        child: Center(
          child: Text(
            'Tour Album',
            style: TextStyle(
              fontSize: 50,
              color: Colors.black,
            ),
          ),
        ));
  }

  Widget buildButtons(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.08),
      child: Column(children: <Widget>[
        createButton(
            new Text(
              "Continue Without Account",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                color: Colors.white,
              ),
            ),
            context,
            _continue),
        createButton(
            new Text(
              "Login",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            context,
            _login),
      ]),
    );
  }

  Padding createButton(
      Widget text, BuildContext context, void Function() onPressed) {
    //to create the buttons for the main screen
    return Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
        child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.05,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              //side: BorderSide(color: Colors.blue)
            ),
            child: RaisedButton(
              child: text,
              color: Colors.black,
              onPressed: onPressed,
            )));
  }

  Future askPermissions() async {
    await [Permission.location, Permission.storage, Permission.camera]
        .request();
  }

  void _continue() {
    _toast("Not yet implemented...", Colors.white, Colors.red);
  }

  void _login() {
    Navigator.of(context).pushNamed("/login", arguments: FormType.login);
  }

  void _toast(txt, txtColor, backColor) {
    Fluttertoast.showToast(
        msg: txt,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backColor,
        textColor: txtColor,
        fontSize: 14.0);
  }
}

enum FormType { login, register }
