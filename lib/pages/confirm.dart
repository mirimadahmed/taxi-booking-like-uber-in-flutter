import 'package:flutter/material.dart';
import 'package:moover/widgets/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class ConfirmPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConfirmPageState();
  }
}

class ConfirmPageState extends State<ConfirmPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
//      backgroundColor: Colors.transparent,
      appBar: AppBar(

        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(64, 236, 120, 1.0),
            ),
            onPressed: () {}),
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
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  )),
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
                                Text(
                                  "Ikea Ottobrunn",
                                  style: TextStyle(
                                      color: Color.fromRGBO(112, 112, 112, 1),
                                      fontSize: 16),
                                )
                              ],
                            ),
                            Expanded(child: Container()),
                            Icon(
                              Icons.add,
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
                                Text(
                                  "Hauptbahnhof",
                                  style: TextStyle(
                                      color: Color.fromRGBO(112, 112, 112, 1),
                                      fontSize: 16),
                                )
                              ],
                            ),
                            Expanded(child: Container()),
                            Icon(
                              Icons.clear,
                              color: Color.fromRGBO(64, 236, 120, 1.0),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
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
                          "Wartezeit : 4 Min",
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
                          "22,34 €",
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
                              Navigator.pushReplacementNamed(context, "/place");
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
                          height: 20,
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
