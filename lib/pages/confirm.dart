import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moover/pages/standardscreen.dart';
import 'package:moover/widgets/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:moover/widgets/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConfirmPageState();
  }
}

class ConfirmPageState extends State<ConfirmPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Map<MarkerId,Marker> markers = <MarkerId,Marker>{};
  NetworkUtil network = new NetworkUtil();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(picData.lat, picData.lng),
    zoom: 17.0,
  );
  String DestAsddress;
  String PicAddress;
  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    print(picData.lat);
    print(picData.lng);
    Future.delayed(Duration(seconds: 2), (){
      setState(() {
        mapController.moveCamera(
          CameraUpdate.newLatLng(
            LatLng(picData.lat, picData.lng),
          ),
        );
        markers[MarkerId("345")] =Marker(
          markerId: MarkerId("345"),
          draggable: false,
          position: LatLng(picData.lat, picData.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow:
          InfoWindow(title: "Your Location", snippet: 'Pickup'),
        );
      });
    });
    network.getAddress(picData.lat, picData.lng).then((res){
      print("getting address");
      setState(() {
        PicAddress = res.toString();
      });
    });
    network.getAddress(dropData.lat, dropData.lng).then((res){
      print("getting address");
      setState(() {
        DestAsddress = res.toString();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      left: false,
      right: false,
      child: Scaffold(
//      backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: controller == null ? Text("") : InkWell(
            child: Text("Cancel"),
            onTap: (){
              setState(() {
                controller.dispose();
                controller = null;
              });
            },
          ),
          leading: IconButton(
              icon: Icon(
               Icons.arrow_back,
                color: _controller != null ? Colors.transparent : Color.fromRGBO(64, 236, 120, 1.0),
              ),
              onPressed:controller != null ? null : () {
                Navigator.of(context).pop();
              }
              ),
          elevation: 0,
        ),
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
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      scrollGesturesEnabled: false,
                      markers: Set<Marker>.of(markers.values),
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          mapController=controller;
                        },
                    )),
               controller != null ? Container():Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 105.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 4, top: 5),
                        height: 50,
                        width: 2,
                        color: Color.fromRGBO(64, 236, 120, 1.0),
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(64, 236, 120, 1.0)),
                                width: 10,
                                height: 10,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Abholort",
                                    style: TextStyle(
                                        color: Color.fromRGBO(112, 112, 112, 1),
                                        fontSize: 12),
                                  ),
                                  PicAddress == null ? Container() :
                                 LimitedBox(
                                   maxWidth: MediaQuery.of(context).size.width /1.5,
                                     child:Text(
                                    "$PicAddress",
                                    style: TextStyle(
                                        color: Color.fromRGBO(112, 112, 112, 1),
                                        fontSize: 16),
                                   overflow: TextOverflow.ellipsis,
                                  )),
                                ],
                              ),
                              Expanded(child: Container()),
                              Icon(
                                Icons.location_on,
                                color: Color.fromRGBO(64, 236, 120, 1.0),
                              )
                            ],
                          ),
                          Container(
                            child: Divider(),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(64, 236, 120, 1.0)),
                                width: 10,
                                height: 10,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Destination Location",
                                    style: TextStyle(
                                        color: Color.fromRGBO(112, 112, 112, 1),
                                        fontSize: 12),
                                  ),
                                  LimitedBox(
                                    maxWidth: MediaQuery.of(context).size.width/1.5,
                                    child: Text(
                                      DestAsddress ?? "",
                                      style: TextStyle(
                                          color: Color.fromRGBO(112, 112, 112, 1),
                                          fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                              Expanded(child: Container()),
                              Icon(
                                Icons.location_off,
                                color: Color.fromRGBO(64, 236, 120, 1.0),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                controller == null ? Positioned(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            "Entfernung : ${distance.distance}",
                            style: TextStyle(color: Colors.white,fontSize: 14),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Betrag",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ), Text(
                            "${selectedAmount.amount ?? ""} €",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {
                                setState(() {
                                  controller = AnimationController(
                                      duration: const Duration(milliseconds: 500), vsync: this);
                                  animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
                                  animation.addStatusListener((status) {
                                    if (status == AnimationStatus.completed) {
                                      controller.reverse();
                                    } else if (status == AnimationStatus.dismissed) {
                                      controller.forward();
                                    }
                                  });
                                  controller.forward();
                                });
                              } ,
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
                            height: 20,
                          ),
                        ],
                      ),
                    )) :
                Positioned(
                  bottom: 0,
                  child: FadeTransition(
                    opacity: animation,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text("Finding your driver", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}












//    SharedPreferences.getInstance().then((picupLocation)async{
//      var decode = jsonDecode(picupLocation.getString("pickupLocation"));
//      var dest = jsonDecode(picupLocation.getString("destLocation"));
//      print("dest : $dest");
//      setState(() {
//        DestAsddress = dest["address"];
//      });
//       Future.delayed(Duration(seconds: 2), (){
//        setState(() {
//          mapController.moveCamera(
//            CameraUpdate.newLatLng(
//              LatLng(decode["lat"], decode["lng"]),
//            ),
//          );
//          markers[MarkerId("345")] =Marker(
//            markerId: MarkerId("345"),
//            draggable: true,
//            position: LatLng(decode["lat"], decode["lng"]),
//            icon: BitmapDescriptor.defaultMarkerWithHue(
//              BitmapDescriptor.hueOrange,
//            ),
//            infoWindow:
//            InfoWindow(title: "Your Location", snippet: 'Pickup'),
//          );
//        });
//      });
//
//      setState(() {
//        markers[MarkerId("345")] =Marker(
//          markerId: MarkerId("345"),
//          draggable: true,
//          position: LatLng(decode["lat"], decode["lng"]),
//          icon: BitmapDescriptor.defaultMarkerWithHue(
//            BitmapDescriptor.hueOrange,
//          ),
//          infoWindow:
//          InfoWindow(title: "Your Location", snippet: 'Pickup'),
//
//        );
//      });
//      final coordinates = new Coordinates(
//          decode["lat"], decode["lng"]);
//      var addresses = await Geocoder.local.findAddressesFromCoordinates(
//          coordinates);
//      setState(() {
//        first = addresses.first;
//      });
//
//      print("PickupLocation Address");
//      print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
//
//      return first;
//    });
