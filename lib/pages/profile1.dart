import 'package:flutter/material.dart';

// This app is a stateful, it tracks the user's current choice.
class Profile1Page extends StatefulWidget {

  @override
  _Profile1PageState createState() => _Profile1PageState();
}

class _Profile1PageState extends State<Profile1Page> with SingleTickerProviderStateMixin{
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


    child: Column( children: <Widget>[TextFormField(

      style: TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter some text';
                    }
                    return null;
                  },
                  initialValue: 'Mikey',
                ),
                SizedBox(height: 10,),
                TextFormField(
                  style: TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
//                    labelText: 'Mechito',labelStyle: TextStyle(color: Colors.black),
//                    contentPadding: EdgeInsets.all(0.0)
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter some text';
                    }
                    return null;
                  },
                  initialValue: 'Mechito',
                ),

    SizedBox(height: 10,),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Geburtstag',labelStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter some text';
                    }
                    return null;
                  },
                ),

    SizedBox(height: 30,),
                Center(
//                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: FlatButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('Processing Data',)));
                      }
                    },
                    child: Text('Speichern',style: TextStyle(color: Color.fromRGBO(32,110,65,1.0),fontSize: 18)),
                  ),
                ),])),
              ],
            ),
          )

        ),

      ),
    );
  }
}
