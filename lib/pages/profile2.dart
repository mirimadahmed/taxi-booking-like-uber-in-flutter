import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:moover/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moover/main.dart';
// This app is a stateful, it tracks the user's current choice.
class Profile2Page extends StatefulWidget {
  @override
  _Profile2PageState createState() => _Profile2PageState();
}

class _Profile2PageState extends State<Profile2Page>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _selected;
  bool update = false;
String _num;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Kontaktdaten bearbeiten",
            style: TextStyle(color: Colors.grey, fontSize: 16.0),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Container(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 0.5,
                color: Colors.grey,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Column(children: <Widget>[
//                    TextFormField(
//                      decoration: const InputDecoration(
//                          hintText: 'mustermail@muster.com',
////                    labelText: 'mustermail@muster.com',
////                    labelStyle: TextStyle(color: Colors.black),
//                          contentPadding: EdgeInsets.all(0.0)),
//                      validator: (value) {
//                        if (value.isEmpty) {
//                          return 'Enter some text';
//                        }
//                        return null;
//                      },
//                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        CountryCodePicker(
                          onChanged: print,
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: 'IT',
                          favorite: ['+39', 'FR'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                        ),
                        Flexible(
                            child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration:
                              const InputDecoration(hintText: "00000"
//                    labelText: 'Mechito',
//                    labelStyle: TextStyle(color: Colors.black),
//                    contentPadding: EdgeInsets.all(0.0),
//                    icon: Icons.

                                  ),
                          validator: (value) {
                            if (int.tryParse(value) == null) {
                              return 'Enter some text';
                            }
                            return null;
                          },
                              onSaved: (val){
                            setState(() {
                              _num = val;
                            });
                              },
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
//                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: update ?
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(32,110,65,1.0)),
                      ): FlatButton(
                        onPressed: () async{
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          print("update number");
                          print(_num);

                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() {
                              update = true;
                            });
                            // If the form is valid, display a Snackbar.
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            CollectionReference snapshot = Firestore.instance.collection("riders");
                            print("snapshot.document(currentUserModel.id)");
                            await snapshot.document(currentUserModel.id).updateData({
                              "phone" : _num != null ? _num : currentUserModel.phone,
                            }).then((res)async{
                              DocumentSnapshot userRecord = await Firestore.instance.collection('riders').document(currentUserModel.id).get();
                              prefs.setString("user", jsonEncode(userRecord.data));
                              currentUserModel =  User.fromDocument(userRecord);

                              setState(() {
                                update = false;
                              });
                              _showSnackBar("Phone number updated successfully");
                            }).catchError((err){
                              print("phone update err");
                              _showSnackBar("Some thing went wrong contact adminstrator");
                            });
                          }
                        },
                        child: Text('Speichern',
                            style: TextStyle(
                                color: Color.fromRGBO(32, 110, 65, 1.0),
                                fontSize: 18)),
                      ),
                    )
                  ])),
            ],
          ),
        )),
      ),
    );
  }
  void _showSnackBar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Color.fromRGBO(32,110,65,1.0),
      content: Text(message),
      duration: Duration(seconds: 5),
    ));
  }
}
