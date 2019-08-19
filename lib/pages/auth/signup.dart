import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../models/authModel.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }
}

class _Login extends State<SignUp> {
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _passwordController = TextEditingController();
  bool _progress = false;
  String _email;
  String _password;

  void _showSnackBar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(message),
      duration: Duration(seconds: 5),
    ));
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        fillColor: Color(0xFFf7f6f6),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        hintText: 'Email',
        hintStyle:
            TextStyle(color: Colors.grey[500], fontSize: 18.0, height: 1.0),
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
      validator: (value) {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);

        if (value.trim().isEmpty || !regex.hasMatch(value)) {
          return "Invalid Email";
        }
      },
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
        hintStyle:
            TextStyle(color: Colors.grey[500], fontSize: 18.0, height: 1.6),
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
      validator: (String val) {
        if (val.trim().length < 6) {
          return "Password must be atleast six characters long";
        }
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
        decoration: InputDecoration(
          fillColor: Color(0xFFf7f6f6),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          hintText: 'Confirm Password',
          hintStyle:
              TextStyle(color: Colors.grey[500], fontSize: 18.0, height: 1.6),
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
        validator: (String value) {
          if (value.trim().length < 6) {
            return "Password must be atleast six characters long";
          } else if (_passwordController.text != value) {
            return "Passwords must match";
          }
        },
        onSaved: (String value) {
          _password = value;
        });
  }

  Widget _buildLoginBtn() {
    return Container(
      width: (90.0),
      height: MediaQuery.of(context).size.height * 6 / 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Material(
        child: MaterialButton(
          padding: EdgeInsets.only(left: 0.0, right: 0.0),
          child: Text(
            'Continue',
            style: TextStyle(
                fontFamily: 'SFUID-Medium',
                fontSize: 17.0,
                color: Colors.black45),
          ),
          onPressed: () {
            if (!_loginForm.currentState.validate()) {
              return;
            }
            setState(() {
              _progress = true;
            });

            _loginForm.currentState.save();

            AuthModel().signup(email: _email.toLowerCase(),password: _password).then((resp){
              setState(() {
                _progress = false;
              });
              print(resp);
              if(resp["success"]){
                Navigator.pushNamed(context, '/register');
              }else{
                _showSnackBar(resp["message"]);
              }
            });
          },
          highlightColor: Colors.lightBlueAccent.withOpacity(0.5),
          splashColor: Colors.lightGreenAccent.withOpacity(0.5),
        ),
        color: Colors.transparent,
      ),
    );
  }


  Widget _buildcreateAccountInkWell() {
    return InkWell(
        child: Text(
          'Login',
          style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'SFUID-Medium',
              color: Colors.white,
              height: 2.0),
          textAlign: TextAlign.right,
        ),
        onTap: () {
          setState(() {
            Navigator.pushReplacementNamed(context, '/');
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: Container(
        color: Color(0xfff40e878),
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30),

          child: Form(
            key: _loginForm,
            child: ListView(
            children: <Widget>[
              Container(
                height: 120,
                width: 120,
                child: Image(image: AssetImage('assets/car-white.png')),
                margin: EdgeInsets.only(top: 100),
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
              _buildConfirmPasswordTextField(),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _progress
                      ? Center(child: new CircularProgressIndicator())
                      :_buildLoginBtn(),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'SFUID-Medium',
                        color: Colors.black,
                        height: 2.0),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  _buildcreateAccountInkWell()
                ],
              )
            ],
          ),),
        ),
      ),
    );
  }
}
