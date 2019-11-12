import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moover/models/location_data.dart';
import 'package:moover/pages/confirm.dart';
import 'package:moover/pages/searchPage.dart';
import 'package:moover/widgets/route.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';
import '../widgets/network.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart';
import '../main.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import '../widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyB81xMeMewP3-P3KyUloVMJnvVEhgfHgrI";

class StandardScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StandardScreenPageState();
  }
}

SelectedLocationData picData = new SelectedLocationData();
SelectedLocationData dropData = new SelectedLocationData();
SelectedLocationData distance = new SelectedLocationData();
SelectedLocationData notiz = new SelectedLocationData();
SelectedLocationData selectedAmount = new SelectedLocationData();


class StandardScreenPageState extends State<StandardScreenPage> {

  GoogleMapsPlaces _places1 = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  final GlobalKey<ScaffoldState> _homeScaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _position;
  CameraPosition _position1;
  String address = "";
  MarkerId selectedMarker;
  bool point = false;
  bool pick = true;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  List<LatLng> ccc = [];
  NetworkUtil network = new NetworkUtil();
  String loacationAddress = "Loading...";
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String username = "";
  Mode _mode = Mode.overlay;
  LatLng destination;
  bool _myLocationEnabled = false;
  bool _myLocationButtonEnabled = false;
  bool _ploylineMap = false;
  bool _goingToPolyLineMap = false;
  bool add = false;
  double amount = 22.34;
  TextEditingController _controllerNote;
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

    await Future.delayed(Duration(seconds: 2));
    return currentLocation;

  }

  _getUserData()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user");

  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }


  static  double zm = 14.4746;
  static  CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  bool z = false;
  bool cr = false;
  bool cs = false;
  @override
  void initState() {
    super.initState();
    _controllerNote = TextEditingController();
      getUserLocation().then((currentLocations)async{

        setState(() {
          picData = SelectedLocationData(lat: currentLocations.latitude, lng: currentLocations.longitude);
          destination = LatLng(currentLocations.latitude, currentLocations.longitude);
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        Map addresss = Map();
        addresss = {
          "lat" : currentLocations.latitude,
          "lng" : currentLocations.longitude,
        };
        print(addresss);
        var encode = jsonEncode(addresss);
        prefs.setString("pickupLocation", encode);
        setState(() {
          mapController.moveCamera(
            CameraUpdate.newLatLng(
              LatLng(currentLocations.latitude, currentLocations.longitude),
            ),
          );
        });
      });
    SharedPreferences.getInstance().then((fav){
      setState(() {
        z = fav.get("zuhause") != null ? true : false;
        cr = fav.get("crownClub") != null ? true : false;
        cs = fav.get("casino") != null ? true : false;
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
    Orientation orientation = MediaQuery.of(context).orientation;
    return SafeArea(
      bottom: true,
      left: false,
      right: false,
      top: false,
      child: Scaffold(
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
                    child: selectedDest && !_ploylineMap ?
                    GoogleMap(
                      myLocationEnabled: _myLocationEnabled,
                      myLocationButtonEnabled: _myLocationButtonEnabled,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(37.42796133580664, -122.085749655962),
                        zoom: zm,
                      ),
                      onMapCreated: _onMapCreated,
                      markers: Set<Marker>.of(markers.values),
                      onCameraMove: _myLocationEnabled ? _updateCameraPosition1 : _updateCameraPosition,
                    ) :
                   _ploylineMap ? GoogleMap(
                     initialCameraPosition: _kGooglePlex,
                      polylines: Set<Polyline>.of(polylines.values),
                     markers: Set<Marker>.of(markers.values),
                   )
                        : GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: _onMapCreated,
                    )),
                selectedDest ? Container(
                  height: 50.0,
                  width: 50.0,
                  margin: EdgeInsets.only(left: 10.0, top: 40),
                  child: FittedBox(
                    child: FloatingActionButton(
                      onPressed:!_myLocationEnabled ? () {
                        setState(() {
                          _position1 = null;
                          _position = null;
                          destpost = null;
                          pickpost = null;
                          positionByScrolled = false;
                          selectedDest = false;
                          markers.remove(MarkerId("120"));
                          markers.remove(MarkerId("360"));
                          mapController.moveCamera(CameraUpdate.newLatLng(LatLng(destination.latitude,destination.longitude)));
                        });
                      } : _ploylineMap  ?
                      (){
                        setState(() {
                          _ploylineMap = false;
                          _goingToPolyLineMap = false;
                          ccc = [];
                          polylines ={};
                        });
                      }:
                          (){
                        setState(() {
                          _myLocationEnabled = false;
                          mapController.moveCamera(
                              CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng( _position != null ? _position.target.latitude : destpost.result.geometry.location.lat, _position != null ? _position.target.longitude : destpost.result.geometry.location.lng),
                                    bearing: 270,
                                    zoom: 16.0,
                                    tilt: 30,
                                  )
                              )
                          );
                          markers[MarkerId("120")] = Marker(
                            markerId: MarkerId("120"),
                            position: LatLng(_position != null ? _position.target.latitude : destpost.result.geometry.location.lat, _position != null ? _position.target.longitude : destpost.result.geometry.location.lng),
                          );
                        });
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
                ) : Container(
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
             selectedDest &&  !searchAutocomplete && !_ploylineMap ? Positioned(
                top: 100,
                left: 20,
                right: 20,
                child: InkWell(
                  onTap: (){
                    _showAutocomplete(callagain: true);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: Colors.white,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_myLocationEnabled ? "pickup" : "dropoff", style: TextStyle(color: Colors.grey),),
                            Icon(Icons.search, color: Colors.grey,),
                          ],
                        )),
                  ),
                ),
              ) : Container(),
              selectedDest ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: !_myLocationEnabled ? RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Color.fromRGBO(64, 236, 120, 1.0),
                    onPressed: searchinDest ? null :(){
                      setState(() {
                        _myLocationEnabled = true;
                        mapController.moveCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng( _position1 != null ? _position1.target.latitude: pickpost != null ? pickpost.result.geometry.location.lat :destination.latitude, _position1 != null ? _position1.target.longitude : pickpost!=null ? pickpost.result.geometry.location.lng :destination.longitude),
                                  bearing: 270,
                                  zoom: zm,
                                  tilt: 30,
                                ),
                            ));
                        markers[MarkerId("360")] = Marker(
                          icon: BitmapDescriptor.defaultMarkerWithHue(120.0),
                          markerId: MarkerId("360"),
                          position: LatLng(  _position1 != null ? _position1.target.latitude: pickpost != null ? pickpost.result.geometry.location.lat :destination.latitude, _position1 != null ? _position1.target.longitude : pickpost!=null ? pickpost.result.geometry.location.lng :destination.longitude),
                        );
                      });
                    },
                    child: Text("ZIEL BESTÄTIGEN",style: TextStyle(fontSize: 16,color: Colors.white),),
                  ) : _ploylineMap ?
                  Container(
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
                                onPressed: add ? null :() {
                                  setState(() {
                                    add = true;
                                    amount = amount + 5.0;
                                  });
                                },
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
                                onPressed: () {
                                  if(amount > 12.34){
                                    setState(() {
                                      add = false;
                                      amount = amount - 5;
                                    });
                                  }
                                },
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
                        InkWell(
                          onTap: (){
                            _showDialog(copan: true);
                          },
                          child: Center(
                            child: Text(
                              "Gutscheincode",
                              style: TextStyle(color: Colors.white),
                            ),
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
                                  "$amount €",
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
                                onPressed: () {
                                  _showDialog();
                                },
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
                              setState(() {
                                selectedAmount = SelectedLocationData(amount: amount.toString());
                              });
                              Navigator.push(context, PageTransition(child: ConfirmPage(), type: PageTransitionType.rightToLeft));
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
                  )


                      : RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Color.fromRGBO(64, 236, 120, 1.0),
                    onPressed: _goingToPolyLineMap ? null : (){
                      setState(() {
                        _goingToPolyLineMap = true;
                      });
                        getPolyline(
                            _position1 != null ? _position1.target.latitude: pickpost != null ? pickpost.result.geometry.location.lat :destination.latitude, _position1 != null ? _position1.target.longitude : pickpost!=null ? pickpost.result.geometry.location.lng :destination.longitude,
                            _position != null ? _position.target.latitude : destpost.result.geometry.location.lat, _position != null ? _position.target.longitude : destpost.result.geometry.location.lng
                        ).then((_){
                          setState(() {
                            picData = SelectedLocationData(
                              lat:_position1 != null ? _position1.target.latitude: pickpost != null ? pickpost.result.geometry.location.lat :destination.latitude,
                              lng: _position1 != null ? _position1.target.longitude : pickpost!=null ? pickpost.result.geometry.location.lng :destination.longitude,
                            );
                            dropData = SelectedLocationData(
                                lat: _position != null ? _position.target.latitude : destpost.result.geometry.location.lat,
                                lng: _position != null ? _position.target.longitude : destpost.result.geometry.location.lng
                            );

                          });
                        });
                    },
                    child: Text( _goingToPolyLineMap ? "Loading.." :"ABHOLORT BESTÄTIGEN",style: TextStyle(fontSize: 16,color: Colors.white),),
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
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Hello ${currentUserModel.username}!",
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
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              height: 40,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("address engiben",style: TextStyle(color: Colors.grey),)),
                            ),
                            onTap: (){
                              _showAutocomplete(callagain: false);
                            }
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
                                onTap: z ? (){
                                  Navigator.of(context).push(PageTransition(type: PageTransitionType.rightToLeft, child: SearchPage(
                                    zuhause: true,
                                  )));
                                } : null,
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
                                onTap: cr ? () {
                                  Navigator.of(context).push(PageTransition(type: PageTransitionType.rightToLeft, child: SearchPage(
                                    crown: true,
                                  )));
                                } : null,
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
                                onTap: cs ? () {
                                  Navigator.of(context).push(PageTransition(type: PageTransitionType.rightToLeft, child: SearchPage(
                                    casino: true,
                                  )));
                                } : null,
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
        drawer:  DrawerWidgetPage(),
      ),
    );
  }


  bool selectedDest = false;
  bool searchAutocomplete = false;
  dynamic destpost;
  dynamic pickpost;
  _showAutocomplete({bool callagain}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      setState(() {
        selectedDest = true;
        searchAutocomplete = true;
      });
      Prediction p = await PlacesAutocomplete.show(
        logo: Container(
          height: 1,
        ),
        hint: _myLocationEnabled ? "Pickup" : "Drop off",
        context: context,
        apiKey: kGoogleApiKey,
        mode: _mode,
        language: "en",
        radius: 15000,
        location: Location(destination.latitude, destination.longitude),
      );
      PlacesDetailsResponse place = await _places1.getDetailsByPlaceId(p.placeId);
      Map addresss = Map();
      addresss = {
        "lat" : place.result.geometry.location.lat,
        "lng" : place.result.geometry.location.lng,
        "address" : place.result.formattedAddress,
        "name" : place.result.name
      };
      print(addresss);
      var encode = jsonEncode(addresss);
      prefs.setString(_myLocationEnabled ? "pickup" : "dest", encode);
      setState(() {
        zm = 16.0;
        if(_myLocationEnabled){
          pickpost = place;
          picData = SelectedLocationData(lat: place.result.geometry.location.lat, lng: place.result.geometry.location.lng, address: place.result.formattedAddress);
        }else{
          destpost = place;
          dropData = SelectedLocationData(lat: place.result.geometry.location.lat, lng: place.result.geometry.location.lng, address: place.result.formattedAddress);
        }
        mapController.moveCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(place.result.geometry.location.lat, place.result.geometry.location.lng),
                  bearing: 270,
                  zoom: zm,
                  tilt: 30,
                )
            )
        );
        markers[ _myLocationEnabled ? MarkerId("360") :MarkerId("120")] = Marker(
          icon: _myLocationEnabled? BitmapDescriptor.defaultMarkerWithHue(120.0) :BitmapDescriptor.defaultMarker,
          markerId: _myLocationEnabled ? MarkerId("360") : MarkerId("120"),
          position: LatLng(place.result.geometry.location.lat, place.result.geometry.location.lng),
        );
        setState(() {
          positionByScrolled = true;
          searchAutocomplete = false;
        });
        print("selectedLocationData");
        print(dropData.lng);
        print(dropData.lat);
        print(dropData.address);
      });

    }catch(e){
      setState(() {
        selectedDest = callagain != null && callagain == true ? true : false;
        searchAutocomplete = false;
      });
      print(e);
    }
  }



  bool searchinDest = false;
  bool positionByScrolled = false;
  void _updateCameraPosition(CameraPosition position) async{
    setState(() {
      searchinDest = true;
    });
    setState(() {
      _position = position;
    });
    if(selectedDest == true && positionByScrolled == true)
      print("this is the result");
    print(_position.target.latitude);
    if(mounted)
    setState(() {
      picData = SelectedLocationData(lat: _position.target.latitude, lng: _position.target.longitude);
      zm = 16.0;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(_position.target.latitude, _position.target.longitude),
                bearing: 270,
                zoom: zm,
                tilt: 30,
              )
          ),
        );
        markers[ MarkerId("120")] = Marker(
          markerId: MarkerId("120"),
          position: LatLng(_position.target.latitude, _position.target.longitude),
//          infoWindow: InfoWindow(
////            title: "Click to change location",
////            onTap: (){
////              _showAutocomplete(callagain: true);
////            }
//          )
        );
        searchinDest = false;
      });

  }


  void _updateCameraPosition1(CameraPosition position) async{
    setState(() {
      _position1 = position;
    });
      print("this is the result");
    print(_position1.target.latitude);
    setState(() {
      dropData = SelectedLocationData(lat: _position1.target.latitude, lng: _position1.target.longitude);
      zm = 16.0;
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(_position1.target.latitude, _position1.target.longitude),
              bearing: 270,
              zoom: zm,
              tilt: 30,
            )
        ),
      );
      markers[MarkerId("360")] = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(120.0),
          markerId: MarkerId("360"),
          position: LatLng(_position1.target.latitude, _position1.target.longitude),
//          infoWindow: InfoWindow(
////              title: "Change your drop location from here",
////              onTap: (){
////              }
//          )
      );

      searchinDest = false;
    });
  }


  Future getPolyline(originLat,originLng,destLat,destLng) async {
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
        List<Steps> rr = res["steps"];
        print("distancedistance");

        print(res["distance"]);
        setState(() {
          distance = SelectedLocationData(distance: res["distance"].toString());
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
      if(mounted)
        setState(() {
          _ploylineMap = true;
          polylines[PolylineId("poly1")] = Polyline(polylineId: PolylineId("poly1"),points: ccc, width: 5);
        });
    }catch(_){
      setState(() {
        _goingToPolyLineMap = false;
        _showSnackBar("Some thing went wrong");
      });
    }
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


  _showDialog({bool copan = false}){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(copan ? "Enter your copan code" : "Enter your message for driver"),
          content: Container(
            child: TextField(
              decoration: InputDecoration(
                labelText: copan ? "Copane code" :'Message',
                hintText: copan ? "" : 'your message',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.green),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("OK", style: TextStyle(color: Colors.green),),
              onPressed: copan ? (){
                Navigator.pop(context);
              }:(){
                setState(() {
                  notiz = SelectedLocationData(notiz: _controllerNote.text ?? "");
                });
                Navigator.pop(context);
              },
            ),

          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        );
      }
    );
  }
}










//
//
//
//
//
//onTap: ()async{
//final SharedPreferences prefs = await SharedPreferences.getInstance();
//print("ok");
//Prediction p = await PlacesAutocomplete.show(
//logo: Container(
//height: 1,
//),
//context: context,
//apiKey: kGoogleApiKey,
//hint: "Hauptbahnhof",
//onError: (res) {
//_homeScaffoldKey.currentState.showSnackBar(
//SnackBar(content: Text(res.errorMessage)));
//},
//mode: _mode,
//language: "en",
//radius: 15000,
////                          location: Location(currentLocation.latitude, currentLocation.longitude),
//
//);
//print("pppppp");
//print("$p");
//if(p != null){
//FocusScope.of(context).requestFocus(FocusNode());
//displayPrediction(p, _scaffoldKey.currentState, context)
//    .then((res){
//if(res != null)
//print("addressaddress");
//print(res["address"]);
//Map addresss = Map();
//addresss = {
//"lat" : res["latitude"],
//"lng" : res["longitude"],
//};
//print(addresss);
//var encode = jsonEncode(addresss);
//prefs.setString("pickupLocation", encode);
//setState(() {
//address = res["address"];
//loacationAddress = res["address"];
//destination = LatLng(res["latitude"], res["longitude"]);
//mapController.moveCamera(
//CameraUpdate.newLatLng(
//LatLng(res["latitude"], res["longitude"]),
//),
//);
//
//markers[MarkerId("120")] = Marker(
//markerId: MarkerId("120"),
//draggable: true,
//position: LatLng(res["latitude"], res["longitude"]),
//icon: BitmapDescriptor.defaultMarkerWithHue(
//BitmapDescriptor.hueGreen,
//),
//infoWindow:
//InfoWindow(title: "Picup location", snippet: '*'),
//onTap: () => _onMarkerTapped(
//MarkerId("120"),
//),
//);
//});
//});
//}
//
//
//},






//    var geolocator = Geolocator();
//    print("callled");
//    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

//    StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
//            (Position position) {
//              setState(() {
//                mapController.moveCamera(
//                  CameraUpdate.newLatLng(
//                    LatLng(position.latitude, position.longitude),
//                  ),
//                );
//              });
//              print("fastest 1");
//          print(position == null ? 'Unknown  ' : position.latitude.toString() + ', ' + position.longitude.toString());
//        });