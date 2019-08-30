import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import '../widgets/network.dart';
import '../widgets/route.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart';
import '../main.dart';
import '../models/authModel.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import '../widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
class StandardScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StandardScreenPageState();
  }
}


class StandardScreenPageState extends State<StandardScreenPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();

  MarkerId selectedMarker;
  bool point = false;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  NetworkUtil network = new NetworkUtil();
  String loacationAddress = "Loading...";
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String username = "";

    getUserLocation() async {
    //call this async method from wherever you need

    loc.LocationData currentLocation;
    var myLocation;
    String error;
    loc.Location location = new loc.Location();
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
    print(currentLocation.latitude);
    print(currentLocation.longitude);
    return currentLocation;

  }

  _getUserData()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user");

  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    getUserLocation();
    _getUserData().then((data){
      print("user data");
      var dta = jsonDecode(data);
      setState(() {
        username = dta["username"];
      });
      print(dta["username"]);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
//      backgroundColor: Colors.transparent,

      key: _scaffoldKey,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: _onMapCreated,
                  )),
              Container(
                height: 50.0,
                width: 50.0,
                margin: EdgeInsets.only(left: 10.0, top: 40),
                child: FittedBox(
                  child: FloatingActionButton(
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    backgroundColor: Color.fromRGBO(64, 236, 120, 1.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(64, 236, 120, 1.0),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10))),
                    padding: EdgeInsets.all(10),
//                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 2,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(247, 247, 247, 1)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Hello "+username+"!",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Wo können wir dir helfen?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Adresse eingeben",
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/home.png",
                                    height: 70,
                                    width: 70,
                                  ),
                                  Text(
                                    "Zuhause",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )
                                ],
                              ),
                              onTap: () => Navigator.pushNamed(
                                  context, "/search"),
                            ),
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/clock.png",
                                    height: 70,
                                    width: 70,
                                  ),
                                  Text(
                                    "Crowns Club",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )
                                ],
                              ),
                              onTap: () => Navigator.pushNamed(
                                  context, "/search"),
                            ),
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/clock.png",
                                    height: 70,
                                    width: 70,
                                  ),
                                  Text(
                                    "Filmcasino",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )
                                ],
                              ),
                              onTap: () => Navigator.pushNamed(
                                  context, "/search"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ))
            ],
          )),
      drawer: DrawerWidgetPage(),
    );
  }
}
