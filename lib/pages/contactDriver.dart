import 'package:flutter/material.dart';
import 'package:moover/widgets/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class contactDriverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return contactDriverPageState();
  }
}

class contactDriverPageState extends State<contactDriverPage> {
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
                  child: Image.asset(
                    "assets/München.png",
                    fit: BoxFit.fitHeight,
                  )),
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
                      Icons.clear,
                      color: Colors.white,
                    ),
                    backgroundColor: Color.fromRGBO(64, 236, 120, 1.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  ),
                ),
              ),
              Positioned(
                  bottom: 50,
                  left: 40,
                  right: 40,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(64, 236, 120, 1.0),
                        borderRadius:
                            BorderRadius.all( Radius.circular(10))),
                    padding: EdgeInsets.all(10),
//                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Dein Fahrer",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              "4 min",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(247, 247, 247, 1)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                         Row(
                          children: <Widget>[
                            ClipRRect(
                              child: Image.asset(
                                "assets/profileImage.jpg",
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
                                  "Alex",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "Mercedes Sprinter -\ninkl. Hilfe",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
]),
                            SizedBox(
                              width: 20,
                            ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(

                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)
                                  ),

                                  child: Icon(
                                    Icons.phone,
                                    color: Color.fromRGBO(111, 111, 111, 1),
                                  ),
                                ) , SizedBox(
                              width: 10,
                            ),Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(

                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Icon(
                                    Icons.mail,
                                    color: Color.fromRGBO(111, 111, 111, 1),
                                  ),
                                )
                              ],
                            )
                          ],
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
