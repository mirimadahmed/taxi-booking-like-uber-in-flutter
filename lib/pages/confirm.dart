
import 'dart:convert';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:moover/main.dart';
import 'package:moover/pages/standardscreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:moover/widgets/network.dart';
import 'package:moover/widgets/route.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ConfirmPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ConfirmPageState();
  }
}

class ConfirmPageState extends State<ConfirmPage> with TickerProviderStateMixin {
  final Firestore _firestore = Firestore.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;
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
    manager = SocketIOManager();
    _socketConnect();
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
      if(mounted)
      setState(() {
        DestAsddress = res.toString();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disconnect();
  }




  List userData = [
    {
      "userid": currentUserModel.id,
      "username" : currentUserModel.username,
      "phone" : currentUserModel.phone,
      "photoUrl" : currentUserModel.photoUrl,
      "rating" : currentUserModel.rating
    }
  ];
  SocketIOManager manager;
  SocketIO socket;
  String socketUrl = "https://moover-server.herokuapp.com/";
  String socketUrllocal = "http://localhost:3000";
  String socketUrllocal1 = "http://192.168.10.5:3000";
  List<String> toPrint = ["trying to connect"];

  _socketConnect()async{

    socket = await manager.createInstance(SocketOptions(
      socketUrl,
      enableLogging: true,
      query: {
        "auth": "--SOME AUTH STRING---",
        "info": "new connection from adhara-socketio",
        "timestamp": DateTime.now().toString()
      },
      transports: [Transports.WEB_SOCKET, Transports.POLLING],

    ));
    socket.onConnect((res){
      print("Connected..");
      print(res);
      sendMessage();
    });
    socket.on("got ride", (data) => gotRide(data));
    socket.on("user back", (data) => pprint);
//    socket.on("driver location", (data) => handleListen(data));
    socket.onConnectError(pprint);
    socket.onConnectTimeout(pprint);
    socket.onError(pprint);
    socket.onDisconnect(pprint);
    socket.connect();
  }



  bool isgot = false;

  gotRide(data)async{
    await checkRide(data);
    print("got rides");
    print(data.toString());
    if(data["userId"] == currentUserModel.id && isgot == false){
      setState(() {
        controller.dispose();
        controller = null;
        riderdata = data;
        isgot = true;
      });
      database.reference().child("ride").child(riderdata["key"]).onValue.listen((res)async{
        print("driver update data");
        if(mounted || res.snapshot.value["driverLat"] != null)
        setState(() {
          markers[MarkerId(riderdata["id"])] = Marker(
            markerId: MarkerId(riderdata["id"]),
            draggable: true,
            position: LatLng(res.snapshot.value["driverLat"], res.snapshot.value["driverlng"]),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
//         infoWindow: InfoWindow(title: "Your Location", snippet: 'Pickup'),
//         onTap: () => _onMarkerTapped(
//           MarkerId("345"),
//         ),
          );
        });
        await getPolyline(picData.lat, picData.lng, res.snapshot.value["driverLat"], res.snapshot.value["driverlng"]);
      });
    }
  }

  Map _driverlocationUpdated = Map();
  handleListen(data)async{
    print("updated driver location");
    if(data.key == riderdata["key"]) {
      setState(() {
        _driverlocationUpdated = data;
        markers[MarkerId(riderdata["id"])] = Marker(
          markerId: MarkerId(riderdata["id"]),
          draggable: true,
          position: LatLng(data["driverLat"], riderdata["driverlng"]),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
//         infoWindow: InfoWindow(title: "Your Location", snippet: 'Pickup'),
//         onTap: () => _onMarkerTapped(
//           MarkerId("345"),
//         ),
        );
      });
      await getPolyline(picData.lat, picData.lng, data["driverLat"], riderdata["driverlng"]);
    }
  }

  Map riderdata = Map();
  checkRide(data){
    if(riderdata["isBooked"] == true){
      SharedPreferences.getInstance().then((res){
        res.setBool("isBook", riderdata["isBooked"]);
      });
    }
  }


  disconnect() async {
    await manager.clearInstance(socket);
  }

  sendMessage() {
    if (socket!= null) {
      socket.emit("connect user", userData);
    }
  }

  pprint(data) {
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }
      print(data);
      toPrint.add(data);
    });
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
                color: controller != null ? Colors.transparent : Color.fromRGBO(64, 236, 120, 1.0),
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
                    child: !_ploylineMap ? GoogleMap(
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      scrollGesturesEnabled: false,
                      markers: Set<Marker>.of(markers.values),
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          mapController=controller;
                        },
                    ) : GoogleMap(
                      markers: Set<Marker>.of(markers.values),
                      polylines: Set<Polyline>.of(polylines.values),
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
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

//                                itemRef.push().set({
//                                  "id" : currentUserModel.id,
//                                  "pLat" : picData.lat,
//                                  "pLng" : picData.lng,
//                                  "dLat" : dropData.lng,
//                                  "dLng" : dropData.lng,
//                                  "pAdderss" : PicAddress,
//                                  "dAdderss" : DestAsddress,
//                                  "distance" : distance.distance,
//                                  "amount" : selectedAmount.amount,
//                                  "riderRank" : currentUserModel.rating.toString(),
//                                  "name" : currentUserModel.username,
//                                  "phone" : currentUserModel.phone,
//                                  "photo" : currentUserModel.photoUrl,
//                                  "timestamp" : DateTime.now().millisecondsSinceEpoch.toString(),
//                                  "isBooked" : false
//                                }).then((_){
//                                  setState(() {
//                                    controller = AnimationController(
//                                        duration: const Duration(milliseconds: 500), vsync: this);
//                                    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
//                                    animation.addStatusListener((status) {
//                                      if (status == AnimationStatus.completed) {
//                                        controller.reverse();
//                                      } else if (status == AnimationStatus.dismissed) {
//                                        controller.forward();
//                                      }
//                                    });
//                                    controller.forward();
//                                  });
//                                  Future.delayed(Duration(seconds: 5), (){
//                                    setState(() {
//                                      controller.dispose();
//                                      controller = null;
//                                    });
//                                    _showSnackBar("There is no driver available for now");
//                                  });
//                                }).catchError((err) => print(err));

                              var ridesData = [
                                {
                                  "id" : currentUserModel.id,
                                  "pLat" : picData.lat,
                                  "pLng" : picData.lng,
                                  "dLat" : dropData.lat,
                                  "dLng" : dropData.lng,
                                  "pAdderss" : PicAddress,
                                  "dAdderss" : DestAsddress,
                                  "distance" : "${distance.distance} KM",
                                  "amount" : selectedAmount.amount,
                                  "riderRank" : currentUserModel.rating,
                                  "name" : currentUserModel.username,
                                  "phone" : currentUserModel.phone,
                                  "photo" : currentUserModel.photoUrl,
                                  "timestamp" : DateTime.now().millisecondsSinceEpoch.toString(),
                                  "isBooked" : false
                                }
                              ];

                                if(socket != null){
                                  socket.emitWithAck("give ride", ridesData);
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
                                }

//                                var documentRefrence = _firestore.collection("riders").document(currentUserModel.id).collection("rides").document(DateTime.now().millisecondsSinceEpoch.toString());
//                                _firestore.runTransaction((transation)async{
//                                  await transation.set(documentRefrence, {
//                                    "id" : currentUserModel.id,
//                                      "pLat" : picData.lat,
//                                      "pLng" : picData.lng,
//                                      "dLat" : dropData.lng,
//                                      "dLng" : dropData.lng,
//                                      "pAdderss" : PicAddress,
//                                      "dAdderss" : DestAsddress,
//                                      "distance" : "${distance.distance} KM",
//                                      "amount" : selectedAmount.amount,
//                                      "riderRank" : currentUserModel.rating,
//                                      "name" : currentUserModel.username,
//                                      "phone" : currentUserModel.phone,
//                                      "photo" : currentUserModel.photoUrl,
//                                       "timestamp" : DateTime.now().millisecondsSinceEpoch.toString(),
//                                       "isBooked" : false
//                                  });
//                                }).then((res){
//                                  setState(() {
//                                    controller = AnimationController(
//                                        duration: const Duration(milliseconds: 500), vsync: this);
//                                    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
//                                    animation.addStatusListener((status) {
//                                      if (status == AnimationStatus.completed) {
//                                        controller.reverse();
//                                      } else if (status == AnimationStatus.dismissed) {
//                                        controller.forward();
//                                      }
//                                    });
//                                    controller.forward();
//                                  });
//                                  Future.delayed(Duration(seconds: 5), (){
//                                    setState(() {
//                                      controller.dispose();
//                                      controller = null;
//                                    });
//                                    _showSnackBar("There is no driver available for now");
//                                  });
//                                  print(res.toString());
//                                }).catchError((err){print(err);});

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
                  top: 0,
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


  bool _ploylineMap = false;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Future getPolyline(originLat,originLng,destLat,destLng) async {
    print("user pickup");
    print(destLat);
    print(destLng);
    try{
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
        polylines.clear();
        ccc.clear();
        List<Steps> rr = res["steps"];
        for (final i in rr) {
          print("i.polyline");
          print(i.polyline);
          decodePoly(i.polyline);
        }
      });
      if(mounted)
        setState(() {
          _ploylineMap = true;
          polylines[PolylineId("poly1")] = Polyline(polylineId: PolylineId("poly1"),points: ccc, width: 5);
        });
    }catch(_){
      setState(() {
        _showSnackBar("Some thing went wrong");
      });
    }
  }
  List<LatLng> ccc = [];
  void decodePoly(String encoded) {
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      var b, shift = 0, result = 0;
      do {
        var asc = encoded.codeUnitAt(index++);
        b = asc - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        var asc = encoded.codeUnitAt(index++);
        b = asc - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      ccc.add(LatLng(lat / 100000.0, lng / 100000.0));
    }
  }


  void _showSnackBar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
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
