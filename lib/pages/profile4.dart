import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

// This app is a stateful, it tracks the user's current choice.
class ZuhausePage extends StatefulWidget {

  @override
  _ZuhausePageState createState() => _ZuhausePageState();
}

class _ZuhausePageState extends State<ZuhausePage> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  String address = "";
  String loacationAddress = "Loading...";
  LatLng destination;
  Mode _mode = Mode.overlay;
  final GlobalKey<ScaffoldState> _homeScaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
          title: Text("Mein Adressbuch",style: TextStyle(color: Colors.grey,fontSize: 16.0),),
          backgroundColor: Colors.transparent,
          leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.grey,),
            onPressed:() => Navigator.pop(context, false),
          ),

        ),
        body:Container (
          child: Column(
            children: <Widget>[
              Container(height: 0.5,color: Colors.grey,),
              Container(
                height: 50,
                color: Colors.grey,
                child: InkWell(
                  onTap: ()
                  async{
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
                        addresss = {
                          "lat" : res["latitude"],
                          "lng" : res["longitude"],
                          "address" : res["address"],
                        };
                        print(addresss);
                        var encode = jsonEncode(addresss);
                        prefs.setString("pickupLocation", encode);
                        setState(() {
                          address = res["address"];
                        });
                      });
                    }


                  },
                ),
              ),
            ],
          ),
        ),

      ),
    );
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






/// old code
//child: Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Container(height: 0.5,color: Colors.grey,),
//SizedBox(height: 20,),
//Container (
//
//padding: EdgeInsets.all(10),
//
//
//child: GestureDetector(onTap: (){}, child: Row(
//mainAxisAlignment: MainAxisAlignment.spaceBetween,
//children: <Widget>[
//Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Text("Zuhause",style: TextStyle(fontSize: 18,color: Color.fromRGBO(32,110,65,1.0),),),
//Text("Erstelle einen Favoriten für dein Zuhause",style: TextStyle(fontSize: 16,color: Color.fromRGBO(32,110,65,1.0),),)
//],
//),
//IconButton(icon: Icon(Icons.chevron_right), onPressed: (){}),
//],
//))),
//Container(height: 1,color: Colors.grey,),
////                  Expanded(child: Container()),
////                  Container(
////                    padding: EdgeInsets.symmetric(horizontal: 10),
////                    child: ButtonTheme(
////                      minWidth: MediaQuery.of(context).size.width,
////                      child: RaisedButton(
////                      padding: EdgeInsets.all(10),
////                      shape: RoundedRectangleBorder(
////                          borderRadius: BorderRadius.circular(10)),
////                      onPressed: () {},
////                      child: Text(
////                        "Favoriten hinzufügen",
////                        style: TextStyle(color: Colors.white, fontSize: 16),
////                      ),
////                      color: Color.fromRGBO(32, 110, 65, 1.0),
////                    ),),
////                  ),
//SizedBox(
//height: 10,
//)
//],
//),
