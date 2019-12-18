
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:moover/main.dart';
import 'package:moover/pages/rate.dart';
import 'package:moover/pages/standardscreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:moover/widgets/network.dart';
import 'package:moover/widgets/route.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'payment.dart';
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
  var duration = "0.0 mins";
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(picData.lat, picData.lng),
    zoom: 17.0,
  );
  String DestAsddress;
  String PicAddress;
  AnimationController controller;
  Animation<double> animation;
  bool driverView = false;
  bool lottiePlay = false;
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


  endRide(){
    print("finished");

  }

  bool isgot = false;

  gotRide(data)async{
    await checkRide(data);
    print("got rides");
    print(data.toString());
    if(data["userId"] == currentUserModel.id && isgot == false){
      setState(() {
        lottiePlay = false;
        riderdata = data;
        isgot = true;
      });
      database.reference().child("ride").child(riderdata["key"]).onValue.listen((res)async{
        try{
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
        }catch(e){
          print(e.toString());
        }
      });
      database.reference().child("ride").child(riderdata["key"]).onChildRemoved.listen((_){
        database.reference().child("ride").child(riderdata["key"]).onValue.listen((_){}).cancel();
        database.reference().child("ride").child(riderdata["key"]).onChildRemoved.listen((_){}).cancel();
             Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.rightToLeft
             ,child: RatePage(
                   imageUrl: riderdata["photoUrl"],
                   name: riderdata["username"],
                   rating: riderdata["rating"].toString(),
                   driverId: riderdata["id"],
             ),
               curve: Curves.fastOutSlowIn
             ),);
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
    print("dissconnecttd");
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
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
      bottom: true,
      top: false,
      left: false,
      right: false,
      child: Scaffold(
//      backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: !isgot && controller == null ? Text("") : InkWell(
            child: !isgot ? Text("Cancel") : Text(""),
            onTap: !isgot ? (){
              setState(() {
                controller.dispose();
                controller = null;
              });
            } : null,
          ),
          leading: IconButton(
              icon: Icon(
               Icons.arrow_back,
                color: lottiePlay && !isgot ? Colors.transparent : !isgot ? Color.fromRGBO(64, 236, 120, 1.0) : Colors.transparent,
              ),
              onPressed:lottiePlay && !isgot ? null : () {
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
                lottiePlay ? Container(

               ):

               Container(
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
                !isgot && !lottiePlay ? Positioned(
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                             InkWell(
                          onTap: progreeDialog ? null :(){
                            _showDialogPaypal();
                          },
                               child: Container(
                                 width: w*0.2,
                                 child: Image.asset("assets/paypal.png", fit: BoxFit.fill),
                               ),
                             ),
                              Text(
                                "${selectedAmount.amount ?? ""} €",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap:progreeDialog ? null : (){
                                  _showDialog();
                                },
                                child: Container(
                                  width: w*0.1,
                                  child: Image.asset("assets/stripe.png", fit: BoxFit.fill,),
                                ),
                              ),
                            ],
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
                              onPressed: !progreeDialog ? null :  () {

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
                                  "note" : notiz.notiz,
                                  "id" : currentUserModel.id,
                                  "pLat" : picData.lat,
                                  "pLng" : picData.lng,
                                  "dLat" : dropData.lat,
                                  "dLng" : dropData.lng,
                                  "pAdderss" : PicAddress,
                                  "dAdderss" : DestAsddress,
                                  "distance" : "${distance.distance}",
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
                                    lottiePlay = true;
                                  });
                                  Future.delayed(Duration(seconds: 15),(){
                                    if(!isgot){
                                      setState(() {
                                        lottiePlay = false;
                                      });
                                      return _showSnackBar("There is no driver available for now");
                                    }
                                  });
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
//                                    Future.delayed(Duration(seconds: 15),(){
//                                      if(!isgot){
//                                        setState(() {
//                                          controller.dispose();
//                                          controller = null;
//                                        });
//                                        return _showSnackBar("There is no driver available for now");
//                                      }
//                                    });
//                                  });
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
                lottiePlay ?
//                Positioned(
//                  top: 0,
//                  child: FadeTransition(
//                    opacity: animation,
//                    child: Container(
//                      width: MediaQuery.of(context).size.width,
//                      height: 200,
//                      decoration: BoxDecoration(
//                        color: Colors.blue.withOpacity(0.5),
//                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//                      ),
//                      child: Center(
//                        child: Text("Finding your driver", style: TextStyle(color: Colors.white, fontSize: 20),),
//                      ),
//                    ),
//                  ),
//                )

                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children:[
                      SpinKitRipple(
                      color: Colors.green,
                      size: MediaQuery.of(context).size.width,
                      controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1000)),
                    ),
                      SpinKitPulse(
                        color: Colors.green,
                        size: MediaQuery.of(context).size.width,
                        controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1000)),
                      ),
                    ]
                  ),
                )

                         :
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
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        driverView = !driverView;
                                      });
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Text(!driverView ? "Hide" : "Show", style: TextStyle(color: Colors.white),),
                                        Icon(!driverView ?Icons.arrow_downward : Icons.arrow_upward, color: Colors.white,),
                                      ],
                                    ),
                                  ),
                                ),
                                driverView ? Container() :
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Voraussichtliche Wartezeit: $duration",
                                          style:
                                          TextStyle(color: Colors.white, fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(

//                                  onTap: ()=>Navigator.pushNamed(context, "/contact"),
                                      child:  Row(
                                        children: <Widget>[
                                          riderdata["photoUrl"] != null ? ClipRRect(
                                            child: Container(
                                              color: Colors.white,
                                              child: Image.network(
                                                riderdata["photoUrl"],
                                                width: 50,
                                                height: 50,
                                              ),
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ) :
                                          ClipRRect(
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              child: Icon(Icons.person, color: Colors.white,),
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                riderdata["username"] ?? "",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                "${riderdata["rating"]} Sterne",
                                                style: TextStyle(
                                                    fontSize: 14, color: Colors.white),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),),
                                    Divider(
                                      color: Colors.white,
                                    ),
                                    GestureDetector(child:  Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          child: Image.asset(
                                            "assets/car.png",
                                            width: 50,
                                            height: 50,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Mercedes Sprinter",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              "inkl. Tragehilfe",
                                              style: TextStyle(
                                                  fontSize: 14, color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Expanded(child: Container()),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "22,34 €",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.white)),
                                        )
                                      ],
                                    ),onTap: ()=>Navigator.of(context).push(AddMapOverlay()),),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        )


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
        setState(() {
          duration = res["duration"];
        });
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

bool progreeDialog = false;
  _showDialog(){
    return showDialog(
      context: context,
      builder: (context){
        return CupertinoAlertDialog(
          title: Text("Accetp?"),
          content: Text("Do you accept?"),
          actions: <Widget>[
            CupertinoDialogAction(child: Text("No"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(child: Text("Yes"),
              onPressed: (){
              Navigator.of(context).pop();
              SharedPreferences.getInstance().then((res){
                if(res.get("pId") != null){
                  Firestore.instance.collection("payments").document(currentUserModel.id).collection("charges").add({
                    "amount" : int.parse(selectedAmount.amount) * 100,
                    "currency" : "usd",
                    "description" : "Payment for booking moover taxi"
                  }).then((_){
                    setState(() {
                      progreeDialog = true;
                    });
                  });
                }
                else{
                  Navigator.of(context).push(PageTransition(child: PaymentsPage(), type: PageTransitionType.downToUp));
                }
              });

              },
            ),
          ],
        );
      },
    );
  }

  _showDialogProgressDialog(){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width*0.2),
            child: SpinKitDualRing(color: Colors.green,),
          ),
        );
      }
    );
  }

  _showDialogPaypal(){
    return showDialog(
      context: context,
      builder: (context){
        return CupertinoAlertDialog(
          title: Text("Sorry"),
          content: Text("Paypal not ready for now"),
          actions: <Widget>[
            CupertinoDialogAction(child: Text("ok"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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










class AddMapOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        Stack(children: <Widget>[Center(child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          height: 400.0,
          width: MediaQuery.of(context).size.width * 0.6,
          margin: EdgeInsets.all(10),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Container()),
                    Container(
                      child: Text(
                        'Add new map',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      margin: EdgeInsets.only(top: 10.0),
                    ),
                    Expanded(child: Container()),
                    Align(
                      child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(64, 236, 120, 1.0),
                              borderRadius: BorderRadius.circular(5)),
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
//                    color: Colors.green,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(15.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(  padding: EdgeInsets.symmetric(horizontal: 10.0),child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "VW e-Crafter",
                    style: TextStyle(
                        fontSize: 29, color: Color.fromRGBO(38, 39, 41, 1)),
                  ),
                  Text(
                    "Laderaum: 14 m",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(38, 39, 41, 1)),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.directions_car,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "4",
                        style: TextStyle(
                            fontSize: 16, color: Color.fromRGBO(38, 39, 41, 1)),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.person,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "4",
                        style: TextStyle(
                            fontSize: 16, color: Color.fromRGBO(38, 39, 41, 1)),
                      ),
                    ],
                  )],),),
              SizedBox(
                height: 193.0,
              ),


              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,

                height: 60.0,
                child: Column(children: <Widget>[Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    Container(
                      child: Text(
                        'Länge: 6,00 m',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      margin: EdgeInsets.only(top: 10.0),
                    ), Container(
                      child: Text(
                        'Breite: 1,65 m',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      margin: EdgeInsets.only(top: 10.0),
                    ),


                  ],
                ),Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Container(
                      child: Text(
                        'Höhe: 1,87 m',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),

                    ),


                  ],
                )],),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(64, 236, 120, 1.0),
                    borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15.0))),
              ),
            ],
          ),
        ),),
          Padding(padding:EdgeInsets.only(top: 100) ,child: Image.asset("assets/car.png",height: 300,width: 300,),),
        ],),
        Expanded(
          child: Container(),
        )
      ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}