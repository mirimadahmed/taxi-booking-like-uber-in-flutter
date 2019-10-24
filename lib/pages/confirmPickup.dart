import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moover/widgets/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class ConfirmPickup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConfirmPickupState();
  }
}

class ConfirmPickupState extends State<ConfirmPickup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{

  };


  @override
  void dispose() {
    // TODO: implement dispose
   super.dispose();
  }

  final Marker marker = Marker(
    markerId: MarkerId("Destination"),
    position: LatLng(
        37.42796133580664, -122.085749655962
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen,
    ),
    infoWindow: InfoWindow(title: "Destination", snippet: '*'),
    onTap: () {
//      _onMarkerTapped(markerId);
    },
  );




  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  getPicupLatLng()async{
    await Future.delayed(Duration(seconds: 3));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("pickupLocation");
  }
  @override
  void initState() {
    super.initState();
    getPicupLatLng().then((res){
      var decode = jsonDecode(res);
      setState(() {
        mapController.moveCamera(
          CameraUpdate.newLatLng(
            LatLng(decode["lat"], decode["lng"]),
          ),
        );
        markers[MarkerId("345")] = Marker(
          markerId: MarkerId("345"),
          draggable: true,
          position: LatLng(decode["lat"], decode["lng"]),
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
    });
  }
  MarkerId selectedMarker;
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
    markers[MarkerId("Destination")] = marker;
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
                    markers: Set<Marker>.of(markers.values),
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      mapController=controller;
                    },
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
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Color.fromRGBO(64, 236, 120, 1.0),
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, "/transport");
                    },
                    child: Text("ABHOLORT BESTÄTIGEN",style: TextStyle(fontSize: 16,color: Colors.white),),
                  )
              )
            ],
          )),
      drawer: DrawerWidgetPage(),
    );
  }
}
