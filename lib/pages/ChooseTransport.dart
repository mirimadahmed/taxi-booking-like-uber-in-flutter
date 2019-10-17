import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moover/main.dart';
import 'package:moover/pages/searchPage.dart';
import 'package:moover/widgets/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:moover/widgets/network.dart';
import 'package:moover/widgets/route.dart';
import 'package:shared_preferences/shared_preferences.dart';


const kGoogleApiKey = "AIzaSyB81xMeMewP3-P3KyUloVMJnvVEhgfHgrI";
class ChooseTransportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChooseTransportPageState();
  }
}

class ChooseTransportPageState extends State<ChooseTransportPage> {
  Stream<QuerySnapshot> _drivers;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng pLocation;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((locationPickup)async{
      var decode = jsonDecode(locationPickup.getString("pickupLocation"));
      setState(() {
        pLocation = LatLng(decode["lat"], decode["lng"]);
      });
//      await Future.delayed((Duration(seconds: 2)));
//      setState(() {
//        mapController.moveCamera(
//            CameraUpdate.newLatLng(
//            LatLng(decode["lat"], decode["lng"]),
//          ));
//      });
      setState(() {
               markers[MarkerId("345")] =Marker(
          markerId: MarkerId("345"),
          draggable: true,
          position: LatLng(decode["lat"], decode["lng"]),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow:
          InfoWindow(title: "Your Location", snippet: 'Pickup'),

        );
      });
    });
    _drivers = Firestore.instance.collection("drivers").orderBy("id").snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
//      backgroundColor: Colors.transparent,

      key: _scaffoldKey,
      body: StreamBuilder<QuerySnapshot>(
        stream: _drivers,
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || pLocation == null) {
            return Center(child: const Text('Loading...'));
          }
          return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: StoreMap(
                        markers: markers,
                        documents: snapshot.data.documents,
                        initialPosition: pLocation,
                        mapController: mapController,
                      )),
//                  Container(
//                    height: 50.0,
//                    width: 50.0,
//                    margin: EdgeInsets.only(left: 10.0, top: 40),
//                    child: FittedBox(
//                      child: FloatingActionButton(
//                        onPressed: () {
//                          _scaffoldKey.currentState.openDrawer();
//                        },
//                        child: Icon(
//                          Icons.menu,
//                          color: Colors.white,
//                        ),
//                        backgroundColor: Color.fromRGBO(64, 236, 120, 1.0),
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.all(Radius.circular(16.0))),
//                      ),
//                    ),
//                  ),
                  Container(
                    height: 50.0,
                    width: 50.0,
                    margin: EdgeInsets.only(left: 10.0, top: 40),
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 40,
                        ),
                        backgroundColor: Color.fromRGBO(64, 236, 120, 1.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0))),
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
                        padding: EdgeInsets.only(left:10,right: 10),
//                    height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
//                            Center(
//                              child: Container(
//                                height: 2,
//                                width: 30,
//                                decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(10),
//                                    color: Color.fromRGBO(247, 247, 247, 1)),
//                              ),
//                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Sehr gut!",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Brauchst du Tragehilfe?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width * 0.4,
                                  child: RaisedButton(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    onPressed: () {},
                                    child: Text(
                                      "Ja, Bitte!",
                                      style: TextStyle(
                                          color: Color.fromRGBO(112, 112, 112, 1)),
                                    ),
                                    color: Color.fromRGBO(255, 255, 255, 2),
                                  ),
                                ),
                                ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width * 0.4,
                                  child: RaisedButton(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    onPressed: () {},
                                    child: Text(
                                      "Nein, Danke!",
                                      style: TextStyle(
                                          color: Color.fromRGBO(112, 112, 112, 1)),
                                    ),
                                    color: Color.fromRGBO(255, 255, 255, 2),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Center(
                              child: Text(
                                "Gutscheincode",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Gesamtpreis",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Text(
                                      "22,34 €",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width * 0.4,
                                  child: RaisedButton(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    onPressed: () {},
                                    child: Text(
                                      "Notiz",
                                      style: TextStyle(
                                        color: Color.fromRGBO(64, 236, 120, 1.0),
                                      ),
                                    ),
                                    color: Color.fromRGBO(255, 255, 255, 2),
                                  ),
                                )
                              ],
                            ),

                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, "/confirm");
                                },
                                child: Text(
                                  "WEITER",
                                  style: TextStyle(
                                    color: Color.fromRGBO(112, 112, 112, 1.0),
                                  ),
                                ),
                                color: Color.fromRGBO(255, 255, 255, 2),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ))
                ],
              ));
        },
      ),
      drawer: DrawerWidgetPage(),
    );
  }
}


const _pinkHue = 350.0;

class StoreMap extends StatefulWidget {
  const StoreMap({
    Key key,
    this.markers,
    @required this.documents,
    @required this.initialPosition,
    @required this.mapController,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;
  final GoogleMapController mapController;
  final Map<MarkerId, Marker> markers;

  @override
  _StoreMapState createState() => _StoreMapState();
}

class _StoreMapState extends State<StoreMap> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  NetworkUtil network = new NetworkUtil();
  Map pickLocation = {};
  GoogleMapController mapController;
  @override
  void initState(){
    super.initState();
    setState(() {
      mapController = widget.mapController;
      markers = widget.markers;
    });



  }
  @override
  Widget build(BuildContext context) {
    widget.documents.forEach((document){
      setState(() {
        widget.markers[MarkerId(document["id"])] = document["active"] ? Marker(
          draggable: true,
          markerId: MarkerId(document['id']),
          icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
          position: LatLng(
            document["currentLocation"]["lat"],
            document["currentLocation"]["long"],
          ),
          infoWindow: InfoWindow(
            title: document['username'],
            snippet: document['location'],
          ),
        ): Marker(markerId: MarkerId(document['id']));
      });

    });
    print("markerssss ${markers.length}");
    return markers.length == 1 || markers.length == 0 ? Container() :GoogleMap(
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
                target: widget.initialPosition,
        zoom: 14.0
      ),
markers: Set<Marker>.of(widget.markers.values),
//      markers: widget.documents
//          .map((document){
////////         getPolyline(widget.initialPosition.longitude,widget.initialPosition.longitude,document["currentLocation"]["lat"],document["currentLocation"]["long"]).then((res)async{
////////          print("distance driver from user pickup point");
////////          print(res);
//////////             return Marker(
//////////              markerId: MarkerId(document['id']),
//////////              icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
//////////              position: LatLng(
//////////                document["currentLocation"]["lat"],
//////////                document["currentLocation"]["long"],
//////////              ),
//////////              infoWindow: InfoWindow(
//////////                title: document['username'],
//////////                snippet: document['location'],
//////////              ),
//////////            );
////////        });
////
//         return document["active"] ? Marker(
//          draggable: true,
//          markerId: MarkerId(document['id']),
//          icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
//          position: LatLng(
//            document["currentLocation"]["lat"],
//            document["currentLocation"]["long"],
//          ),
//          infoWindow: InfoWindow(
//            title: document['username'],
//            snippet: document['location'],
//          ),
//        ) : Marker(
//           markerId: MarkerId(document['id'])
//         );
//          }
//        )
//        .toSet(),

      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
    );
  }

  Future getPolyline(originLat,originLng,destLat,destLng) async {
    var distance;
    await network
        .get("origin=" +
        originLat.toString() +
        "," +
        originLng.toString() +
        "&destination=" +
        destLat.toString() +
        "," +
        destLng.toString() +
        "&mode=walking&key=$kGoogleApiKey")
        .then((dynamic res) {
      print(res);
      List<Steps> rr = res["steps"];
      print("distancedistance");
      print(res["distance"]);
      setState(() {
        distance = res["distance"];
      });
    });

    return distance;
  }
}
