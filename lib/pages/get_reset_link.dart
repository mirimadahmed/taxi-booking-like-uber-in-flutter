import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetResetLink extends StatefulWidget {
  @override
  _GetResetLinkState createState() => _GetResetLinkState();
}

class _GetResetLinkState extends State<GetResetLink> {
  bool reset = false;
  TextEditingController _controllerMail;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    _controllerMail = TextEditingController();
  }
  Widget email() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/envelope.png',
            width: 30,
            height: 30,
          ),
          SizedBox(
            width: 7,
          ),
          Expanded(
              child: TextFormField(
            controller: _controllerMail,
            autofocus: false,
            decoration: InputDecoration.collapsed(
              hintText: 'Email',
            ),
          ))
        ],
      ),
    );
  }

  Widget getLinkButton() {
    return ButtonTheme(
        height: 40,
        child: Container(
          margin: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width * 0.9,
          child: RaisedButton(
            padding: EdgeInsets.all(15.0),
            onPressed: reset ? null : () {
              resetPassword(_controllerMail.text);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            child: Text(
              "Forgot",
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.grey, fontSize: 20.0),
            ),
          ),
        ));

//    return InkWell(
//      splashColor: Colors.transparent,
//      onTap: reset ? null :(){
//        resetPassword(_controllerMail.text);
//      },
//      child: Container(
//        width: MediaQuery.of(context).size.width * 0.9,
//        height: 50,
//        margin: EdgeInsets.only(
//          top: 30,
//        ),
//        decoration: BoxDecoration(
//          color: Colors.white,
//          borderRadius: BorderRadius.circular(15),
//        ),
//        child: Center(
//          child: Text(
//            "Forgot",
//            style: TextStyle(color: Colors.grey),
//          ),
//        ),
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xfff40e878),
      body: Container(
        color: Color(0xfff40e878),
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(left: 30, right: 30),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                AnimatedPadding(
                    duration: Duration(microseconds: 400),
                    padding: EdgeInsets.only(bottom: 30),
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(fontSize: 24),
                    )),
                email(),
                getLinkButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> resetPassword(String email) async {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    if (email == null) {
      _showSnackBar("Provide email", Colors.white, Colors.black);
    } else if (regExp.hasMatch(email)) {
      setState(() {
        reset = true;
      });
      try{
        await _firebaseAuth.sendPasswordResetEmail(email: email).then((res){
          Navigator.pushReplacementNamed(context, '/');
          print("Don");
        });
      }catch(e){
        setState(() {
          reset = false;
        });
        print("exception");
        _showSnackBar("email does not exist", Colors.white, Colors.black);
        print(e);
      }

    } else {
      _showSnackBar("Provide correct email", Colors.white, Colors.black);
    }
  }

  void _showSnackBar(message, Color color, Color color1) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(message, style: TextStyle(color: color1)),
      duration: Duration(seconds: 2),
    ));
  }
}
