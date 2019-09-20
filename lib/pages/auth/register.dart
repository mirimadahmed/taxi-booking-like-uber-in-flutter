import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../models/authModel.dart';
import 'package:location/location.dart' as LocationPlugin;
import 'package:flutter/services.dart';
// This app is a stateful, it tracks the user's current choice.
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _progress = false;
  CountryCode _selected =CountryCode(
      name: "Deutschland", code: "DE", dialCode: "+49");
  String _gender, _name, _num,city;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  String lat = "",lng = "";
  @override
  void initState() {
    super.initState();
    getUserLocation().then((currentLocation){
      setState(() {
        lat = currentLocation.latitude.toString();
        lng = currentLocation.longitude.toString();
      });
      print(lat);
      print(lng);
    });

  }

  getUserLocation() async {
    //call this async method from wherever you need

    LocationPlugin.LocationData currentLocation;
    var myLocation;
    String error;
    LocationPlugin.Location location = new LocationPlugin.Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    currentLocation = myLocation;


    print("raxi");

    return currentLocation;

  }
  void _showSnackBar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(message),
      duration: Duration(seconds: 5),
    ));
  }


  Widget userGender() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            )),
        child: DropdownButtonHideUnderline(
            child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: Text(
                    "Gender",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: _gender,
                  style: TextStyle(color: Colors.grey[300]),
                  items: <String>['Male', 'Female'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ))));
  }

  Widget _buildNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Color(0xFFf7f6f6),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        hintText: 'Name',
        hintStyle:
            TextStyle(color: Colors.grey[500], fontSize: 18.0, height: 1.6),
        contentPadding: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 10.0),
        prefixIcon: Icon(Icons.person),
      ),
      style: TextStyle(height: 0.8, color: Colors.black, fontSize: 18.0),
      validator: (String val) {
        if (val.trim().isEmpty) {
          return "This field can't be left empty";
        }
      },
      onSaved: (value) {
        _name = value;
      },
    );
  }

  Widget userCity() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            )),
        child: DropdownButtonHideUnderline(
            child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: Text(
                    "City",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: city,
                  style: TextStyle(color: Colors.grey),
                  items: <String>['Berlin', 'Lahore'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      city = value;
                    });
                  },
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xfff40e878),
      body: Container(
        color: Color(0xfff40e878),
        child: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
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
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                          _buildNameTextField(),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              CountryCodePicker(
                                onChanged: (val) {
                                  _selected = val;
                                  print(val.name.toString());
                                  print(val.code.toString());
                                },
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: "DE",
                                favorite: ['+39', 'FR'],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,
                                textStyle:
                                    TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                  fillColor: Color(0xFFf7f6f6),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  hintText: '1234567',
                                  hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 18.0,
                                      height: 1.6),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                ),
                                style: TextStyle(
                                    height: 0.8,
                                    color: Colors.black,
                                    fontSize: 18.0),
                                validator: (value) {
                                  if (int.tryParse(value) == null) {
                                    return 'Kindly enter valid number';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  _num = val;
                                },
                              ))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          userGender(),SizedBox(
                            height: 20,
                          ),
//                        userCity(),
                          SizedBox(
                            height: 50,
                          ),
                          _progress
                              ? Center(child: new CircularProgressIndicator())
                              : Center(
//                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      if (!_formKey.currentState.validate()) {
                                        return;
                                      }
                                      setState(() {
                                        _progress = true;
                                      });

                                      _formKey.currentState.save();

                                      AuthModel()
                                          .registerInfo(
                                              location:
                                                  _selected.toCountryStringOnly(),
                                              gender: _gender,
                                              userName: _name,
                                              phone: _selected.dialCode + _num,
                                      lat: lat,
                                        lng: lng,
                                      )
                                          .then((res) {
                                        setState(() {
                                          _progress = false;
                                        });
                                        print(res);
                                        if(res['success']){
                                          Navigator.pushReplacementNamed(context, "/");
                                        }else{
                                          _showSnackBar(res['message']);
                                        }
                                      });
                                    },
                                    child: Text('Let\'s Start',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                  ),
                                )
                        ])),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
