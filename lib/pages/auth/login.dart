import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/authModel.dart';
import '../../main.dart';
import '../../models/userModel.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }
}

class _Login extends State<Login> {
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  bool _progress = false;

  String _email;
  String _password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  void _showSnackBar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(message),
      duration: Duration(seconds: 5),
    ));
  }

  Future<Null> _setUpNotifications() async {
    if (Platform.isAndroid) {
//      _firebaseMessaging.configure(
//        onMessage: (Map<String, dynamic> message) async {
//          print('on message $message');
//        },
//        onResume: (Map<String, dynamic> message) async {
//          print('on resume $message');
//        },
//        onLaunch: (Map<String, dynamic> message) async {
//          print('on launch $message');
//        },
//      );
//
//      _firebaseMessaging.getToken().then((token) {
//        print("Firebase Messaging Token: " + token);
//
//        Firestore.instance
//            .collection("riders")
//            .document(currentUserModel.id)
//            .updateData({"androidNotificationToken": token});
//      });
    }
  }




  Widget _buildEmailTextField() {
    return TextFormField(
      focusNode: _emailFocus,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        fillColor: Color(0xFFf7f6f6),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18.0, height: 1.0),
        contentPadding: EdgeInsets.only(top: 4.0, bottom: 4, right: 10.0),
        prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Image(
              image: AssetImage('assets/envelope.png'),
              width: 10,
              height: 10,
            )),
      ),
      style: TextStyle(height: 0.8, color: Colors.black, fontSize: 18.0),
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          fillColor: Color(0xFFf7f6f6),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18.0, height: 1.6),
          contentPadding: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 10.0),
          prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Image(
                image: AssetImage('assets/lock.png'),
                width: 10,
                height: 10,
              )),
        ),
        style: TextStyle(height: 0.8, color: Colors.black, fontSize: 18.0),
        obscureText: true,
        onSaved: (String value) {
          _password = value;
        });
  }

  Widget _buildLoginBtn() {
    return Container(
      child: RaisedButton(
        color: Colors.white,
        padding: EdgeInsets.only(left: 0.0, right: 0.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          'Login',
          style: TextStyle(fontFamily: 'SFUID-Medium', fontSize: 17.0, color: Colors.black45),
        ),
        onPressed: _progress ? null : () async{
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          if (!_loginForm.currentState.validate()) {
            return;
          }
          setState(() {
            _progress = true;
          });

          _loginForm.currentState.save();

          _auth.signInWithEmailAndPassword(email: _email.trim(), password: _password.trim()).then((user)async{
            var ref = Firestore.instance.collection("riders").document(user.user.uid);
            await ref.get().then((doc){
              print("ok1");
              print(doc.data);
              if(doc.exists){
                prefs.setBool("profilecomplete", doc.exists);
                currentUserModel = User.fromDocument(doc);
                prefs.setString("user", jsonEncode(doc.data));
                if(user.user.isEmailVerified){
                  prefs.setString("email", user.user.email);
                  prefs.setString('id', user.user.uid);
                  prefs.setBool("emailverified", true);
                  ref.updateData({
                    "emailvarified" : true,
                    'active': true
                  });
                  setState(() {
                    _progress = false;
                  });
                  Navigator.pushReplacementNamed(context, '/Dashboard');
                }else{
                  setState(() {
                    _progress = false;
                  });
                  _showSnackBar("Kindely active your account");
                }
                setState(() {
                  _progress = false;
                });
              }
              else{
                Navigator.pushNamed(context, '/register');
              }
            });
          }).catchError((err){
            setState(() {
              _progress = false;
            });
            print("erro from login");
            print(err);
            _showSnackBar("Invalid email and password");
          });

//            AuthModel().login(email: _email, password: _password).then((resp) async {
//              print(resp);
//              if (resp["success"]) {
//                DocumentSnapshot userRecord = await Firestore.instance.collection('riders').document(resp["userId"]).get();
//                if (userRecord != null) currentUserModel = User.fromDocument(userRecord);
//                final SharedPreferences prefs = await SharedPreferences.getInstance();
//                prefs.setString("user", jsonEncode(userRecord.data));
//
//                setState(() {
//                  _progress = false;
//                });
//                if (userRecord != null) {
//                  Navigator.pop(context);
//                  _setUpNotifications();
//                  Navigator.pushReplacementNamed(context, '/Dashboard');
//                  Firestore.instance.document("riders/${currentUserModel.id}").updateData({
//                    'active': true
//                    //firestore plugin doesnt support deleting, so it must be nulled / falsed
//                  });
//                }
//              } else {
//                setState(() {
//                  _progress = false;
//                });
//                _showSnackBar(resp["message"]);
//              }
//          });

        },
        highlightColor: Colors.lightBlueAccent.withOpacity(0.5),
        splashColor: Colors.lightGreenAccent.withOpacity(0.5),
      ),
    );
  }

  Widget _buildforgetPasswordInkWell() {
    return InkWell(
        child: Text(
          'Reset Here',
          style: TextStyle(fontSize: 12.0, fontFamily: 'SFUID-Medium', color: Colors.white, height: 2.0),
          textAlign: TextAlign.right,
        ),
        onTap: () {
          setState(() {
            Navigator.pushReplacementNamed(context, '/forget-password');
          });
        });
  }

  Widget _buildcreateAccountInkWell() {
    return InkWell(
        child: Text(
          'Create One',
          style: TextStyle(fontSize: 16.0, fontFamily: 'SFUID-Medium', color: Colors.white, height: 2.0),
          textAlign: TextAlign.right,
        ),
        onTap: () {
            Navigator.pushReplacementNamed(context, '/signup');

        });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("called login first");
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
//      resizeToAvoidBottomPadding: false,
    backgroundColor: Color(0xfff40e878),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xfff40e878),
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Form(
                key: _loginForm,
                child: Column(
              children: <Widget>[
                Container(
                  height: 120,
                  width: 120,
                  child: Image(image: AssetImage('assets/car-white.png')),
                  margin: EdgeInsets.only(top: 150),
                ),
                SizedBox(
                  height: 20,
                ),
                _buildEmailTextField(),
                SizedBox(
                  height: 25,
                ),
                _buildPasswordTextField(),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                   _buildLoginBtn(),

                    Text(
                      'Forget Password?',
                      style: TextStyle(fontSize: 18.0, fontFamily: 'SFUID-Medium', fontWeight: FontWeight.w500, color: Colors.black, height: 2.0),
                      textAlign: TextAlign.right,
                    ),

                    _buildforgetPasswordInkWell()
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontSize: 18.0, fontFamily: 'SFUID-Medium', color: Colors.black, height: 2.0),
                      textAlign: TextAlign.right,
                    ),

                    _buildcreateAccountInkWell()
                  ],
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
