import 'package:flutter/material.dart';
import 'package:moover/widgets/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class PlaceOrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlaceOrderPageState();
  }
}

class PlaceOrderPageState extends State<PlaceOrderPage> {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Voraussichtliche Wartezeit: 4 min",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Icon(
                                Icons.clear,
                                color: Color.fromRGBO(112, 112, 112, 1),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                       GestureDetector(onTap: ()=>Navigator.pushNamed(context, "/contact"),child:  Row(
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
                                  "4.5 Sterne",
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
Navigator.pushReplacementNamed(context, "/rate");
                            },
                            child: Text(
                              "ABHOLUNG BESTÄTIGEN",
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
