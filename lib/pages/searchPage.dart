import 'package:flutter/material.dart';
import 'package:moover/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import '../widgets/network.dart';
import '../widgets/route.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import '../main.dart';
import '../models/authModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}


const kGoogleApiKey = "AIzaSyB81xMeMewP3-P3KyUloVMJnvVEhgfHgrI";
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
  bool point = false;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  NetworkUtil network = new NetworkUtil();
  String loacationAddress = "Loading...";
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Mode _mode = Mode.overlay;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  Future getPolyline(originLat,originLng,destLat,destLng) async {


    await network
        .get("origin=" +
        originLat.toString() +
        "," +
        originLng.toString() +
        "&destination=" +
        destLat.toString() +
        "," +
        destLng.toString() +
        "&mode=walking&key=AIzaSyB81xMeMewP3-P3KyUloVMJnvVEhgfHgrI")
        .then((dynamic res) {
      print(res);
      List<Steps> rr = res["steps"];
      print(res["distance"]);

      for (final i in rr) {
//            ccc.add(map.Location(
//                i.startLocation.latitude, i.startLocation.longitude));
//            ccc.add(map.Location(
//                i.endLocation.latitude, i.endLocation.longitude));
        print(i.polyline);
        decodePoly(i.polyline);
      }
//
    });

    setState(() {
        polylines[PolylineId("poly1")] = Polyline(polylineId: PolylineId("poly1"),points: ccc);
      });
  }



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
      print("lat=${lat / 100000.0}");

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

  getUserLocation() async {
    //call this async method from whereever you need


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



    setState(() {
      mapController.moveCamera(
        CameraUpdate.newLatLng(
          LatLng(currentLocation.latitude, currentLocation.longitude),
        ),
      );
      markers[MarkerId("345")] = Marker(
        markerId: MarkerId("345"),
        draggable: true,
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        ),
        infoWindow:
        InfoWindow(title: "Your Location", snippet: 'Pickup'),
        onTap: () => _onMarkerTapped(
          MarkerId("345"),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getUserLocation();
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
                    initialCameraPosition: _kGooglePlex,
                    markers: Set<Marker>.of(markers.values),
                    onMapCreated: (GoogleMapController controller) {
                      mapController=controller;
                    },
                  )),
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: GestureDetector(
                    onTap: () async {
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
                          location: Location(currentLocation.latitude, currentLocation.longitude));

                      displayPrediction(p, _homeScaffoldKey.currentState, context)
                          .then((v) {
                        print(v["address"]);

                        setState(() {
                          loacationAddress = v["address"];
                          destination = LatLng(v["latitude"], v["longitude"]);
                          mapController.moveCamera(
                            CameraUpdate.newLatLng(
                              LatLng(v["latitude"], v["longitude"]),
                            ),
                          );
                          markers[MarkerId("123")] = Marker(
                            markerId: MarkerId("123"),
                            draggable: true,
                            position: LatLng(v["latitude"], v["longitude"]),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen,
                            ),
                            infoWindow:
                            InfoWindow(title: "Destination", snippet: '*'),
                            onTap: () => _onMarkerTapped(
                              MarkerId("123"),
                            ),
                          );
                        });
                        print(currentLocation.latitude);
                        print(currentLocation.longitude);
                        print(v["latitude"]);
                        getPolyline(31.440807, 74.293950, v["latitude"], v["longitude"]);
                      });
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
            destination==null? Container():  Positioned(
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
                            onTap: () {
                              Firestore.instance.collection("rides").add({
                                "city":currentUserModel.city,
                                "destination":{"address":loacationAddress,"lat":currentLocation.latitude,"long":currentLocation.longitude}
                             , "driver":{},
                                "pickup":{
                                  "address":"Rider Location",
                                  "lat":currentLocation.latitude,
                                  "long":currentLocation.longitude
                                },
                                "rider":currentUserModel.username,
                                "status":false,
                                "timestamp":DateTime.now().millisecondsSinceEpoch.toString(),
                              });
                            },


//                                Navigator.pushReplacementNamed(
//                                context, "/destination"),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Go",
                                      style: TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize: 16),
                                    ),
//                                    Text(
//                                      "2 km",
//                                      style: TextStyle(
//                                          color:
//                                              Color.fromRGBO(149, 157, 172, 1)),
//                                    )
                                  ],
                                ),
//                                Icon(Icons.chevron_right,color: Colors.white,)
                              ],
                            )),),
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
    print(address);

    return {"latitude": lat, "longitude": lng, "address": address};
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