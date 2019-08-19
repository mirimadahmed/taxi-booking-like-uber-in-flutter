import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This app is a stateful, it tracks the user's current choice.
class Profile3Page extends StatefulWidget {

  @override
  _Profile3PageState createState() => _Profile3PageState();
}

class _Profile3PageState extends State<Profile3Page> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text("Passwort ändern",style: TextStyle(color: Colors.grey,fontSize: 16.0),),
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
                Container(
                  height: 0.5,
                  color: Colors.grey,
                ),
                SizedBox(height: 20,),
                Container (


          padding:EdgeInsets.all(10),
          child: Column(
              children: <Widget>[

                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Aktuelles Passwort',labelStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Neues Passwort',labelStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                Row(
                  children: <Widget>[
                    Text("Passwort anzeigen",style: TextStyle(color: Color.fromRGBO(32,110,65,1.0),fontSize: 14),),

                   SizedBox(width: 10,),
                    CupertinoSwitch(
                      value: true,
                      activeColor:  Color.fromRGBO(32, 110, 65, 1.0),
                      onChanged: (bool value) {

                        },
                    ),
//                    Switch(
//                      onChanged: (v){},
//                      value: false,
//                      activeColor: Colors.white,
////                      activeThumbImage: AssetImage("assets/switchOff.png"),
////                      inactiveThumbImage: AssetImage("assets/switchOn.png"),
//
//                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
//                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: FlatButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Processing Data',
                            )));
                      }
                    },
                    child: Text('Speichern',
                        style: TextStyle(
                            color: Color.fromRGBO(32, 110, 65, 1.0),
                            fontSize: 18)),
                  ),
                )]))
              ],
            ),
          )

        ),

      ),
    );
  }
}
