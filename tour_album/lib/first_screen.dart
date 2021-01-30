import 'package:flutter/material.dart';
import 'package:tour_album/login.dart';

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FirstPageContent();
}

class FirstPageContent extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
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
        children: <Widget>[build_title(), build_buttons(context)],
      ),
    ));
  }

  Widget build_title() {
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

  Widget build_buttons(BuildContext context) {
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

  void _continue() {
    print('Clicked continue');
    Navigator.of(context).pushReplacementNamed("/home");
  }

  void _login() {
    //Navigator.of(context).pushNamed("/login", arguments: FormType.login);
      Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new LoginPage(   arguments: FormType.login,
              initial_type: null,))
          );
  }
}

enum FormType { login, register }
