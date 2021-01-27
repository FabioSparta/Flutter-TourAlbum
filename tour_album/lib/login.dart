import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  final FormType initial_type;
  LoginPage({Key key, @required this.initial_type, arguments})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _LoginPageState(initial_type);
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _usernameFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  final TextEditingController _confirmpwFilter = new TextEditingController();
  String _email = "";
  String _password = "";
  String _confirm_pw = "";
  String _username = "";
  FormType _form;

  //FormType _form = FormType
  // .login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  _LoginPageState(FormType initial_type) {
    if (initial_type == FormType.register) {
      _form = FormType.register;
      print(initial_type);
      print(_form);
      _formChange();
    } else {
      _form = FormType.login;
      print(initial_type);
      print(_form);
      _formChange();
    }

    _emailFilter.addListener(_emailListen);
    _usernameFilter.addListener(_usernameListen);
    _passwordFilter.addListener(_passwordListen);
    _confirmpwFilter.addListener(_confirmpwListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _usernameListen() {
    if (_usernameFilter.text.isEmpty) {
      _email = "";
    } else {
      _username = _usernameFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  void _confirmpwListen() {
    if (_confirmpwFilter.text.isEmpty) {
      _confirm_pw = "";
    } else {
      _confirm_pw = _confirmpwFilter.text;
    }
  }

  // Swap in between our two forms, registering and logging in
  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.1, 0.3, 1],
              colors: [Colors.deepPurple, Colors.purple, Colors.blue]),
        ),
        padding: EdgeInsets.all(16.0),
        child: new ListView(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.black,
      title: const Text('Tour Album', style: TextStyle(color: Colors.blue)),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            new Container(
              child: new TextField(
                controller: _emailFilter,
                decoration: new InputDecoration(labelText: 'Email'),
              ),
            ),
            new Container(
              child: new TextField(
                controller: _passwordFilter,
                decoration: new InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            )
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            new Container(
              child: new TextField(
                controller: _emailFilter,
                decoration: new InputDecoration(labelText: 'Email'),
              ),
            ),
            new Container(
              child: new TextField(
                controller: _usernameFilter,
                decoration: new InputDecoration(labelText: 'Username'),
              ),
            ),
            new Container(
              child: new TextField(
                controller: _passwordFilter,
                decoration: new InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ),
            new Container(
              child: new TextField(
                controller: _confirmpwFilter,
                decoration: new InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
            )
          ],
        ),
      );
    }
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('Login'),
              onPressed: _loginPressed,
            ),
            new FlatButton(
              child: new Text('Dont have an account? Tap here to register.'),
              onPressed: _formChange,
            ),
            new FlatButton(
              child: new Text('Forgot Password?'),
              onPressed: _passwordReset,
            )
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('Create an Account'),
              onPressed: _createAccountPressed,
            ),
            new FlatButton(
              child: new Text('Have an account? Click here to login.'),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
  }

  //LOGIN PRESSED
  Future<void> _loginPressed() async {
    print('The user wants to login with $_email and $_password');
    //Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage()),);
    try {
      await Firebase.initializeApp();
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      Navigator.of(context).pushReplacementNamed("/home");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        _toast("No user found for that email.", Colors.white, Colors.red);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        _toast(
            "Wrong password provided for that user.", Colors.white, Colors.red);
      } else {
        _toast("Some connection error occurred..", Colors.white, Colors.red);
      }
    }
  }

  // SIGN UP PRESSED
  _createAccountPressed() async {
    print('The user wants to create an account with $_email and $_password');
    //INPUT VERIFICATIONS
    if (_email == "" ||
        _username == "" ||
        _password == "" ||
        _confirm_pw == "") {
      _toast("All entries must be filled.", Colors.white, Colors.red);
    } else if (_password != _confirm_pw) {
      _toast("Passwords do not match.", Colors.white, Colors.red);
    } else {
      //AUTHENTICATION
      try {
        await Firebase.initializeApp();

        //FIREBASE AUTHENTICATION
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        //FIREBASE
        //REALTIME DATABASE
        FirebaseDatabase(
                databaseURL:
                    'https://touralbum2-39c64-default-rtdb.europe-west1.firebasedatabase.app/')
            .reference()
            .child("users")
            .child(md5.convert(utf8.encode(_email)).toString())
            .set({'username': _username, 'num_friends': 0}).then((onValue) {
          print('Transaction  committed.');
        }).catchError((onError) {
          print("error called " + onError.toString());
        });

        //USER FEEDBACK
        print("Signed Up Sucessfully.");
        _toast("Signed Up Successfully", Colors.black, Colors.green);
        _form == FormType.login;
        _formChange();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          _toast(
              "The password provided is too weak.", Colors.white, Colors.red);
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          _toast("The account already exists for that email.", Colors.white,
              Colors.red);
        }
      } catch (e) {
        _toast("Some connection error occurred.", Colors.white, Colors.red);
        print(e);
      }
    }
  }

  Future<void> _authentication() async {}

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

  void _passwordReset() {
    print("The user wants a password reset request sent to $_email");
    _toast("Not implemented", Colors.white, Colors.black);
  }
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }
