import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:moover/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';
// This app is a stateful, it tracks the user's current choice.
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {


  String address = "";
  String address1 = "";
  String address2 = "";
  String loacationAddress = "Loading...";
  LatLng destination;
  Mode _mode = Mode.overlay;
  final GlobalKey<ScaffoldState> _homeScaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((res){
      if(res.get("zuhause") != null){
        var decode = jsonDecode(res.getString("zuhause"));
        setState(() {
          address = decode["address"];
        });
      }
      if(res.get("crownClub") != null){
        var decode1 = jsonDecode(res.getString("crownClub"));
        setState(() {
          address1 = decode1["address"];
        });
      }
      if(res.get("casino") != null){
        var decode2 = jsonDecode(res.getString("casino"));
        setState(() {
          address2 = decode2["address"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Profil",
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
          padding: EdgeInsets.zero,
          child: ListView(
            children: <Widget>[
              Container(
                height: 1,
                color: Color.fromRGBO(32, 110, 65, 1.0),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 80.00,
                        height: 80.00,
//                              margin: EdgeInsets.only(top: 50.0,left: 20),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: new DecorationImage(
                            image: ExactAssetImage('assets/profileImage.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/rating.png"),
                          alignment: Alignment.bottomRight,
                        )),
                    Text(
                      currentUserModel.username ?? "",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      currentUserModel.email ?? "",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Persönliche Daten",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(32, 110, 65, 1.0)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  currentUserModel.username ?? "",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 18),
                                ),
                                Text(
                                  "-",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 18),
                                ),
                              ],
                            ),
                            IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/profile1");
                                })
                          ],
                        )
                      ])),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Kontakt",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(32, 110, 65, 1.0)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
//                                Row(
//                                  children: <Widget>[
//                                    Image.asset("assets/mail.png"),
//                                    SizedBox(
//                                      width: 5,
//                                    ),
//                                    Text(
//                                      currentUserModel.email ?? "",
//                                      style: TextStyle(
//                                          color: Colors.black54, fontSize: 18),
//                                    )
//                                  ],
//                                ),
                                Row(
                                  children: <Widget>[
                                    Image.asset("assets/call.png"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      currentUserModel.phone ?? "",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 18),
                                    )
                                  ],
                                )
                              ],
                            ),
                            IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/profile2");
                                })
                          ],
                        )
                      ])),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Zuhause",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(32, 110, 65, 1.0)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              address == "" ? "Mein Adressbuch" : address,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                  icon: Icon(Icons.chevron_right),
                                  onPressed: () {
                                    _zuhause(true,false,false);
                                  }),
                            )
                          ],
                        )
                      ])),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Crowns Club",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(32, 110, 65, 1.0)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                        address1 == "" ? "Adressbuch" : address1,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                  icon: Icon(Icons.chevron_right),
                                  onPressed: () {
                                    _zuhause(false,true,false);
                                  }),
                            )
                          ],
                        )
                      ])),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Filmcasino",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(32, 110, 65, 1.0)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              address2 == "" ? "Adressbuch" : address2,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                  icon: Icon(Icons.chevron_right),
                                  onPressed: () {
                                    _zuhause(false,false,true);
                                  }),
                            )
                          ],
                        )
                      ])),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Allgemein",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(32, 110, 65, 1.0)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Passwort ändern",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                            ),
                            IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/profile3");
                                })
                          ],
                        )
                      ])),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      "Ich möchte News und Rabatte via E-Mail, Push oder SMS erhalten. Hierzu werden Standort-, Nutzung- und Inhaltsdaten gemäß unserer Datenschutzerklärung kombiniert. Die Einwilligung kann ich jederzeit widerrufen.")),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(color: Color.fromRGBO(32, 110, 65, 1.0)),
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromRGBO(32, 110, 65, 0.5),
                          ),alignment: Alignment.bottomCenter,
                          height: 22,width: 40,
                        ),
                        Switch(
                          onChanged: (v){},
                          value: false,
                          activeColor: Color.fromRGBO(32, 110, 65, 1.0),
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                        ),
                      ]
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              FlatButton(
                  onPressed: () {

                  },
                  child: Text(
                    "Account löschen",
                    style: TextStyle(
                      color: Color.fromRGBO(32, 110, 65, 1.0),
                    ),
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {},
                  child: Text(
                    "Ausloggen",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  color: Color.fromRGBO(32, 110, 65, 1.0),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  _zuhause(bool zuhause, bool crownClub, bool casino)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("ok");
    Prediction p = await PlacesAutocomplete.show(
      logo: Container(
        height: 1,
      ),
      context: context,
      apiKey: kGoogleApiKey,
      hint: "Hauptbahnhof",
      onError: (res) {
        _homeScaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text(res.errorMessage)));
      },
      mode: _mode,
      language: "en",
      radius: 15000,
//                          location: Location(currentLocation.latitude, currentLocation.longitude),

    );
    print("pppppp");
    print("$p");
    if(p != null){
      displayPrediction(p, _scaffoldKey.currentState, context)
          .then((res){
        if(res != null)
          print("addressaddress");
        print(res["address"]);
        Map addresss = Map();
        if(zuhause == true){
          addresss = {
            "lat" : res["latitude"],
            "lng" : res["longitude"],
            "address" : res["address"],
          };
          var encode = jsonEncode(addresss);
          prefs.setString("zuhause", encode);
        }
        else if(crownClub == true){
          addresss = {
            "lat" : res["latitude"],
            "lng" : res["longitude"],
            "address" : res["address"],
          };
          var encode = jsonEncode(addresss);
          prefs.setString("crownClub", encode);
        }
        else{
          addresss = {
            "lat" : res["latitude"],
            "lng" : res["longitude"],
            "address" : res["address"],
          };
          var encode = jsonEncode(addresss);
          prefs.setString("casino", encode);
        }

        if(zuhause == true){
          setState(() {
            address = res["address"];
          });
        }else if(crownClub == true){
          setState(() {
            address1 = res["address"];
          });
        } else{
          setState(() {
            address2 = res["address"];
          });
        }

      });
    }

  }


  Future displayPrediction(
      Prediction p, ScaffoldState scaffold, BuildContext context) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      final address = detail.result.formattedAddress;
      print("AddressAddress");
      print(address);
      print(lat);
      print(lng);

      return {"latitude": lat, "longitude": lng, "address": address};
    }
  }

}
