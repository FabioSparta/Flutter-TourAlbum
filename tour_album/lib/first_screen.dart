import 'package:flutter/material.dart';

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
      child: new Column(
        children: <Widget>[build_title(), build_buttons(context)],
      ),
    ));
  }

  Widget build_title() {
    return new Container(
        padding: EdgeInsets.all(100.0),
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
      padding: EdgeInsets.all(70.0),
      child: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 40),
            child: ButtonTheme(
                minWidth: 320,
                height: 40,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  //side: BorderSide(color: Colors.blue)
                ),
                child: RaisedButton(
                  child: new Text(
                    "Continue Without Account",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.black,
                  onPressed: Continue,
                ))),
        Padding(
            padding: EdgeInsets.only(top: 40),
            child: ButtonTheme(
              minWidth: 320,
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                //side: BorderSide(color: Colors.blue)
              ),
              child: RaisedButton(
                child: new Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                color: Colors.black,
                onPressed: SignUp,
              ),
            )),
        Padding(
            padding: EdgeInsets.only(top: 40),
            child: ButtonTheme(
              minWidth: 320,
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                //side: BorderSide(color: Colors.blue)
              ),
              child: RaisedButton(
                child: new Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                color: Colors.black,
                onPressed: Login,
              ),
            )),
      ]),
    );
  }

  void Continue() {
    print('Clicked continue');
    Navigator.of(context).pushReplacementNamed("/home");
  }

  void SignUp() {
    Navigator.of(context)
        .pushReplacementNamed("/login", arguments: FormType.register);
  }

  void Login() {
    Navigator.of(context)
        .pushReplacementNamed("/login", arguments: FormType.login);
  }
}

enum FormType { login, register }
