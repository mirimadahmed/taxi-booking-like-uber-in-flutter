import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

// This app is a stateful, it tracks the user's current choice.
class Profile2Page extends StatefulWidget {
  @override
  _Profile2PageState createState() => _Profile2PageState();
}

class _Profile2PageState extends State<Profile2Page>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _selected;

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
                    TextFormField(

                      decoration: const InputDecoration(
                        hintText: 'mustermail@muster.com',
//                    labelText: 'mustermail@muster.com',
//                    labelStyle: TextStyle(color: Colors.black),
                          contentPadding: EdgeInsets.all(0.0)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter some text';
                        }
                        return null;
                      },

                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(children: <Widget>[CountryCodePicker(
                      onChanged: print,
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: 'IT',
                      favorite: ['+39','FR'],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                    ),
                    Flexible(child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: const InputDecoration(
hintText: "17612345678"
//                    labelText: 'Mechito',
//                    labelStyle: TextStyle(color: Colors.black),
//                    contentPadding: EdgeInsets.all(0.0),
//                    icon: Icons.

                          ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter some text';
                        }
                        return null;
                      },
                    ))],),
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
                    )
                  ])),
            ],
          ),
        )),
      ),
    );
  }
}
