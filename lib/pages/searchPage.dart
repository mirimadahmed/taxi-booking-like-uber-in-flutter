import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:moover/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../widgets/network.dart';
import '../widgets/route.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import '../main.dart';
import '../models/authModel.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:http/http.dart' as http;


class SearchPage extends StatefulWidget {
  final bool zuhause, crown, casino;
  SearchPage({this.zuhause,this.casino,this.crown});
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}


final _searchScaffoldKey = GlobalKey<ScaffoldState>();

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _homeScaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  List<LatLng> ccc = [];
  MarkerId selectedMarker;
  loc.LocationData currentLocation;
  LatLng destination;
  LatLng pLocation;
  LatLng dLocation;
  bool point = false;
  bool progress = false;

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  NetworkUtil network = new NetworkUtil();
  String loacationAddress = "Loading...";
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Mode _mode = Mode.overlay;
  double zoom = 14.4647;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom:14.4746,
  );

  Map picupLocation = Map();
  var distance;
  Future getPolyline(originLat,originLng,destLat,destLng) async {
    setState(() {
      ccc = [];
      polylines ={};
      markers[MarkerId("123")] = Marker(
        markerId: MarkerId("123"),
        visible: false,
      );
    });
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

      for (final i in rr) {
//            ccc.add(map.Location(
//                i.startLocation.latitude, i.startLocation.longitude));
//            ccc.add(map.Location(
//                i.endLocation.latitude, i.endLocation.longitude));
        print("i.polyline");
        print(i.polyline);
        decodePoly(i.polyline);
      }
//
    });
    setState(() {
        polylines[PolylineId("poly1")] = Polyline(polylineId: PolylineId("poly1"),points: ccc, width: 5);
      });
  }



  void decodePoly(String encoded) {
    int index = 0, len = encoded.length;
    print("len : $len");
    int lat = 0, lng = 0;

    while (index < len) {
      var b, shift = 0, result = 0;

      do {
        var asc = encoded.codeUnitAt(index++);
        print("asc L $asc");
        b = asc - 63;
        print("b1:$b");
        result |= (b & 0x1f) << shift;
        print("result: $result");
        shift += 5;
        print("shift: $shift");
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      print("dlat1: $dlat");
      lat += dlat;
      print("lat=${lat / 100000.0}");

      shift = 0;
      result = 0;
      do {
        var asc = encoded.codeUnitAt(index++);
        print("ascasc: $asc");
        b = asc - 63;
        print("bbb: $b");
        result |= (b & 0x1f) << shift;
        print("result2: $result");
        shift += 5;
        print("shift: $shift");
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      print("dlng2:$dlng");
      lng += dlng;
      print("lng2: $lng");
      ccc.add(LatLng(lat / 100000.0, lng / 100000.0));
    }
  }

  var picUpAddress = "";
  getAddressFromLatLng(String lat,String lng)async{
    print("latlng");
    print(lat);
    print(lng);
    try{
//      var response = await http.get("https://maps.godogleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCUqW52AXRmuPzQghI877RFrjXHTxCjfkE",);
      var response = await http.get("https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCUqW52AXRmuPzQghI877RFrjXHTxCjfkE",);
      if(response.statusCode.toString() == "200"){
        print("res address");
        var decode = jsonDecode(response.body);
        print(decode["results"][0]["formatted_address"]);
        setState(() {
          picUpAddress = decode["results"][0]["formatted_address"];
        });
      }

    }catch(e){
      print(e);
    }
  }

  getUserLocation() async {
    var myLocation;
    String error;
    loc.Location location = new loc.Location();

    try {
      print("getting location....");
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
    print("Location of my : ${myLocation}");
    return myLocation;
  }
 var first;
  var address = "";
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((picupLocation)async{
        var decode = jsonDecode(picupLocation.getString("pickupLocation"));
        setState(() {
          setState(() {
            pLocation = LatLng(decode["lat"], decode["lng"]);
          });
        });
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          mapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(decode["lat"], decode["lng"]),
            ),
          );
        });
        setState(() {
          markers[MarkerId("345")] =Marker(
            markerId: MarkerId("345"),
            draggable: true,
            position: LatLng(decode["lat"], decode["lng"]),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
            infoWindow:
            InfoWindow(title: "Your Location", snippet: 'Pickup'),

          );
        });
        await getAddressFromLatLng(decode["lat"].toString(), decode["lng"].toString());
      if(picupLocation.get("zuhause") != null && widget.zuhause == true){
        var decode = jsonDecode(picupLocation.getString("zuhause"));
        setState(() {
      loacationAddress = decode["address"];
      destination = LatLng(decode["lat"], decode["lng"]);
      mapController.animateCamera(
      CameraUpdate.newLatLng(
      LatLng(decode["lat"], decode["lng"]),
      ),
      );
          markers[MarkerId("360")] = Marker(
            markerId: MarkerId("360"),
            draggable: true,
            position: LatLng(decode["lat"], decode["lng"]),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow:
            InfoWindow(title: "Destination", snippet: '*'),
            onTap: () => _onMarkerTapped(
              MarkerId("360"),
            ),
          );
        });
        getPolyline(pLocation.latitude, pLocation.longitude, destination.latitude, destination.longitude);
      } else
      if(picupLocation.get("crownClub") != null && widget.crown == true){
        var decode = jsonDecode(picupLocation.getString("crownClub"));
        setState(() {
          loacationAddress = decode["address"];
          destination = LatLng(decode["lat"], decode["lng"]);
          mapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(decode["lat"], decode["lng"]),
            ),
          );
          markers[MarkerId("360")] = Marker(
            markerId: MarkerId("360"),
            draggable: true,
            position: LatLng(decode["lat"], decode["lng"]),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow:
            InfoWindow(title: "Destination", snippet: '*'),
            onTap: () => _onMarkerTapped(
              MarkerId("360"),
            ),
          );
        });
        getPolyline(pLocation.latitude, pLocation.longitude, destination.latitude, destination.longitude);
      } else
      if(picupLocation.get("casino") != null && widget.casino == true){
        var decode = jsonDecode(picupLocation.getString("casino"));
        setState(() {
          loacationAddress = decode["address"];
          destination = LatLng(decode["lat"], decode["lng"]);
          mapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(decode["lat"], decode["lng"]),
            ),
          );
          markers[MarkerId("360")] = Marker(
            markerId: MarkerId("360"),
            draggable: true,
            position: LatLng(decode["lat"], decode["lng"]),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow:
            InfoWindow(title: "Destination", snippet: '*'),
            onTap: () => _onMarkerTapped(
              MarkerId("360"),
            ),
          );
        });
        getPolyline(pLocation.latitude, pLocation.longitude, destination.latitude, destination.longitude);
      }

    });
  }

  getPicupLatLng()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("pickupLocation");
  }
  @override
  void dispose() {
    // TODO: implement dispose
super.dispose();
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
            BitmapDescriptor.hueAzure,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.transparent,

      key: _homeScaffoldKey,
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
                    polylines: Set<Polyline>.of(polylines.values),
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(31.7159, 73.0655),
                      zoom:zoom,
                    ),
                    markers: Set<Marker>.of(markers.values),
                    onMapCreated: (GoogleMapController controller) {
                      mapController=controller;
                    },
                  ),
              ),
              Container(
                height: 50.0,
                width: 50.0,
                margin: EdgeInsets.only(left: 10.0, top: 40),
                child: FittedBox(
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                top: (MediaQuery.of(context).size.height * .2)/1.2,
                left: 20,
                right: 20,
                child: GestureDetector(
                    onTap: () async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      print("onTap");
//                      setState(() {
//                        ccc = [];
//                        polylines ={};
//                        markers[MarkerId("123")] = Marker(
//                          markerId: MarkerId("123"),
//                          visible: false,
//                        );
//                      });
                      // show input autocomplete with selected mode
                      // then get the Prediction selected
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
                          location: Location(pLocation.latitude, pLocation.longitude),
                      );

                      if(p != null){
                        displayPrediction(p, _homeScaffoldKey.currentState, context)
                            .then((v) {
                          print(v["address"]);
                          Map destUser = Map();
                          destUser = {
                            "lat" : v["latitude"],
                            "lng" : v["longitude"],
                            "address" : v["address"]
                          };
                          print("destuser");
                          print(destUser);
                          var encode = jsonEncode(destUser);
                          prefs.setString("destLocation", encode);
                          setState(() {
                            loacationAddress = v["address"];
                            destination = LatLng(v["latitude"], v["longitude"]);
                            mapController.moveCamera(
                              CameraUpdate.newLatLng(
                                LatLng(v["latitude"], v["longitude"]),
                              ),
                            );
                            markers[MarkerId("360")] = Marker(
                              markerId: MarkerId("360"),
                              draggable: true,
                              position: LatLng(v["latitude"], v["longitude"]),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueGreen,
                              ),
                              infoWindow:
                              InfoWindow(title: "Destination", snippet: '*'),
                              onTap: () => _onMarkerTapped(
                                MarkerId("360"),
                              ),
                            );
                          });
                          print("Hauptbahnhof");
                          print(v["latitude"]);
                          getPolyline(pLocation.latitude, pLocation.longitude, v["latitude"], v["longitude"]);
                        });
                      }

                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Hauptbahnhof",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    )),
              ),
            destination==null? Container():
            progress ? Positioned(
              bottom: 15,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                      Color.fromRGBO(64, 236, 120, 1.0),),
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                  ),
                ),
              ),
            ) : Positioned(
                  bottom: 15,
//                  left: 15,
//                  right: 15,

                  child: Container(
//                    height: 30,
                  width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                            Color.fromRGBO(64, 236, 120, 1.0),),child:
                    GestureDetector(
                            onTap: () async{
                              setState(() {
                                progress = true;
                              });
                              print("rides for user");
                              print(currentUserModel.id);
                              Firestore.instance.collection("rides").add({
                                "userId": currentUserModel.id,
                                "city":currentUserModel.city,
                                "destination":{"address":loacationAddress,"lat":destination.latitude,"long":destination.longitude},
                                "driver":{},
                                "pickup":{
//                                  "address":"${first.locality ?? ""}, ${first.thoroughfare ?? ""} ${first.subLocality ?? ""}",
                                  "address":picUpAddress,
                                  "lat":pLocation.latitude,
                                  "long":pLocation.longitude
                                },
                                "rider":currentUserModel.username,
                                "status":false,
                                "timestamp":DateTime.now().millisecondsSinceEpoch.toString(),
                              }).then((res){
                                setState(() {
                                  progress = false;
                                });
//                              Navigator.pushNamed(
//                                context, "/destination");
                              Navigator.pushReplacementNamed(
                                context, "/transport");
                              });
                            },
//                                Navigator.pushReplacementNamed(
//                                context, "/destination"),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Go",
                                      style: TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize: 16),
                                    ),
                                    distance == null ? SizedBox(height: 0.0,) : Text(
                                      distance,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(149, 157, 172, 1)),
                                    )
                                  ],
                                ),
//                                Icon(Icons.chevron_right,color: Colors.white,)
                              ],
                            )),),
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




Future displayPrediction(
    Prediction p, ScaffoldState scaffold, BuildContext context) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    final address = detail.result.formattedAddress;
    final name = detail.result.name;
    print("AddressAddress");
    print(address);
    print(lat);
    print(lng);

    return {"latitude": lat, "longitude": lng, "address": address, "name" : name};
  }
}

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold()
      : super(
    apiKey: kGoogleApiKey,
    language: "en",
  );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
    final body = PlacesAutocompleteResult(onTap: (p) {
      displayPrediction(p, _searchScaffoldKey.currentState, context);
    });
    return Scaffold(key: _searchScaffoldKey, appBar: appBar, body: body);
  }
}















//    currentLocation = myLocation;
//
//
//    print("raxi");
//    return currentLocation;

//    setState(() {
//      mapController.moveCamera(
//        CameraUpdate.newLatLng(
//          LatLng(currentLocation.latitude, currentLocation.longitude),
//        ),
//      );
//      markers[MarkerId("345")] = Marker(
//        markerId: MarkerId("345"),
//        draggable: true,
//        position: LatLng(currentLocation.latitude, currentLocation.longitude),
//        icon: BitmapDescriptor.defaultMarkerWithHue(
//          BitmapDescriptor.hueOrange,
//        ),
//        infoWindow:
//        InfoWindow(title: "Your Location", snippet: 'Pickup'),
//        onTap: () => _onMarkerTapped(
//          MarkerId("345"),
//        ),
//      );
//    });




//    getPicupLatLng().then((res)async{
//      var decode = jsonDecode(res);
//      setState(() {
//        pLocation = LatLng(decode["lat"], decode["lng"]);
//      });
//      await Future.delayed(Duration(seconds: 2));
//      setState(() {
//        mapController.moveCamera(
//          CameraUpdate.newLatLng(
//            LatLng(decode["lat"], decode["lng"]),
//            ),
//          );
//        markers[MarkerId("345")] = Marker(
//          markerId: MarkerId("345"),
//          draggable: true,
//          position: LatLng(decode["lat"], decode["lng"]),
//          icon: BitmapDescriptor.defaultMarkerWithHue(
//            BitmapDescriptor.hueOrange,
//          ),
//          infoWindow:
//          InfoWindow(title: "Your Location", snippet: 'Pickup'),
//          onTap: () => _onMarkerTapped(
//            MarkerId("345"),
//          ),
//        );
//
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
//    });


//    try{
//      getUserLocation().then((currentLocations){
//        print("current location");
//        print(currentLocations.latitude);
//        setState(() {
//          currentLocation = currentLocations;
//        });
//        setState(() {
//          currentLocation = currentLocations;
//          mapController.moveCamera(
//            CameraUpdate.newLatLng(
//              LatLng(currentLocations.latitude, currentLocations.longitude),
//            ),
//          );
//          markers[MarkerId("345")] = Marker(
//            markerId: MarkerId("345"),
//            draggable: true,
//            position: LatLng(currentLocations.latitude, currentLocations.longitude),
//            icon: BitmapDescriptor.defaultMarkerWithHue(
//              BitmapDescriptor.hueOrange,
//            ),
//            infoWindow:
//            InfoWindow(title: "Your Location", snippet: 'Pickup'),
//            onTap: () => _onMarkerTapped(
//              MarkerId("345"),
//            ),
//          );
//        });
//      });
//    }catch(e) {
//      print("EEEEE $e");
//    }








//                        Text(
//                          "Top Ergebnisse",
//                          style: TextStyle(color: Colors.grey, fontSize: 12),
//                        ),
//                        SizedBox(
//                          height: 10,
//                        ),
//                        GestureDetector(
//                            onTap: () => Navigator.pushReplacementNamed(
//                                context, "/destination"),
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Text(
//                                      "Hauptbahnhof Nord",
//                                      style: TextStyle(
//                                          color:
//                                              Color.fromRGBO(112, 112, 112, 1),
//                                          fontSize: 16),
//                                    ),
//                                    Text(
//                                      "2 km",
//                                      style: TextStyle(
//                                          color:
//                                              Color.fromRGBO(149, 157, 172, 1)),
//                                    )
//                                  ],
//                                ),
//                                Icon(Icons.chevron_right)
//                              ],
//                            )),
//                        Divider(),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Text(
//                                  "Hauptbahnhof Nord",
//                                  style: TextStyle(
//                                      color: Color.fromRGBO(112, 112, 112, 1),
//                                      fontSize: 16),
//                                ),
//                                Text(
//                                  "2 km",
//                                  style: TextStyle(
//                                      color: Color.fromRGBO(149, 157, 172, 1)),
//                                )
//                              ],
//                            ),
//                            Icon(Icons.chevron_right)
//                          ],
//                        ),
//                        Divider(),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Text(
//                                  "Hauptbahnhof Nord",
//                                  style: TextStyle(
//                                      color: Color.fromRGBO(112, 112, 112, 1),
//                                      fontSize: 16),
//                                ),
//                                Text(
//                                  "2 km",
//                                  style: TextStyle(
//                                      color: Color.fromRGBO(149, 157, 172, 1)),
//                                )
//                              ],
//                            ),
//                            Icon(Icons.chevron_right)
//                          ],
//                        ),
//                        Divider(),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Text(
//                                  "Hauptbahnhof Nord",
//                                  style: TextStyle(
//                                      color: Color.fromRGBO(112, 112, 112, 1),
//                                      fontSize: 16),
//                                ),
//                                Text(
//                                  "2 km",
//                                  style: TextStyle(
//                                      color: Color.fromRGBO(149, 157, 172, 1)),
//                                )
//                              ],
//                            ),
//                            Icon(Icons.chevron_right)
//                          ],
//                        ),
//                        Divider(),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Text(
//                                  "Hauptbahnhof Nord",
//                                  style: TextStyle(
//                                      color: Color.fromRGBO(112, 112, 112, 1),
//                                      fontSize: 16),
//                                ),
//                                Text(
//                                  "2 km",
//                                  style: TextStyle(
//                                      color: Color.fromRGBO(149, 157, 172, 1)),
//                                )
//                              ],
//                            ),
//                            Icon(Icons.chevron_right)
//                          ],
//                        ),

