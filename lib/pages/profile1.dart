import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:moover/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moover/models/userModel.dart';
// This app is a stateful, it tracks the user's current choice.
class Profile1Page extends StatefulWidget {

  @override
  _Profile1PageState createState() => _Profile1PageState();
}

class _Profile1PageState extends State<Profile1Page> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controller1;
  bool update = false;
  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController(text: currentUserModel.username);
    setState(() {
      dob = currentUserModel.dob;
    });
  }
  var dob = "dd-mm-yyyy";
  _slelectedDate()async{
    DateTime seleted = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if(seleted != null){
      setState(() {
        dob = DateFormat("dd-MM-yyyy").format(seleted).toString();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text("Profil bearbeiten",style: TextStyle(color: Colors.grey,fontSize: 16.0),),
          backgroundColor: Colors.transparent,
          leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.grey,),
            onPressed:() => Navigator.pop(context, false),
          ),

        ),
        body:Container (



          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 0.5,color: Colors.grey,),
                SizedBox(height: 20,),
    Container (

padding: EdgeInsets.all(10),


    child: Column( children: <Widget>[
      TextFormField(
      controller: _controller1,
      style: TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter some text';
                    }
                    return null;
                  },
//                  initialValue: 'Mikey',
                ),
                SizedBox(height: 10,),
//                TextFormField(
//                  style: TextStyle(color: Colors.black87),
//                  decoration: const InputDecoration(
////                    labelText: 'Mechito',labelStyle: TextStyle(color: Colors.black),
////                    contentPadding: EdgeInsets.all(0.0)
//                  ),
//                  validator: (value) {
//                    if (value.isEmpty) {
//                      return 'Enter some text';
//                    }
//                    return null;
//                  },
//                  initialValue: 'Mechito',
//                ),

//                TextFormField(
//                  enabled: false,
//                  decoration: const InputDecoration(
//                    hintText: 'Geburtstag',labelStyle: TextStyle(color: Colors.grey),
//                  ),
//                  validator: (value) {
//                    if (value.isEmpty) {
//                      return 'Enter some text';
//                    }
//                    return null;
//                  },
//                ),
      Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(dob,style: TextStyle(color: Colors.black,fontSize: 16)),
            InkWell(
                onTap: _slelectedDate,
                child: Icon(Icons.calendar_today)),
          ],
        ),
      ),
    Container(
      color: Colors.black.withOpacity(0.5),
      width: MediaQuery.of(context).size.width,
      height: 1,
    ),
    SizedBox(height: 30,),
                Center(
//                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: update ?
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(32,110,65,1.0)),
                  ):FlatButton(
                    onPressed: () async{
                      setState(() {
                        update = true;
                      });
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      CollectionReference snapshot = Firestore.instance.collection("riders");
                      print("snapshot.document(currentUserModel.id)");
                      await snapshot.document(currentUserModel.id).updateData({
                        "username" : _controller1.text != null ? _controller1.text : currentUserModel.username,
                        "dob" : dob != "dd-mm-yyyy" ? dob : currentUserModel.dob,
                      }).then((res)async{
                        DocumentSnapshot userRecord = await Firestore.instance.collection('riders').document(currentUserModel.id).get();
                        prefs.setString("user", jsonEncode(userRecord.data));
                        currentUserModel =  User.fromDocument(userRecord);

                        setState(() {
                          update = false;
                        });
                        _showSnackBar("Username and date's birth updated successfully");
                      }).catchError((err){
                        print("username and dob update error");
                        _showSnackBar("Some thing went wrong contact adminstrator");
                      });
                    },
                    child:
                    Text('Speichern',style: TextStyle(color: Color.fromRGBO(32,110,65,1.0),fontSize: 18)),
                  ),
                ),])),
              ],
            ),
          )

        ),

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
