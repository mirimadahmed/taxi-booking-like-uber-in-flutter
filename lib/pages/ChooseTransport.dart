import 'package:flutter/material.dart';
import 'package:moover/widgets/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class ChooseTransportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChooseTransportPageState();
  }
}

class ChooseTransportPageState extends State<ChooseTransportPage> {
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
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width * 0.4,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 15),
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
                                padding: EdgeInsets.symmetric(vertical: 15),
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
                        SizedBox(
                          height: 10,
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
                                padding: EdgeInsets.symmetric(vertical: 15),
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
