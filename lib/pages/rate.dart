import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class RatePage extends StatefulWidget {
  @override
  _RatePageState createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidgetPage(),
      body: Stack(
          children:[
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
            Center(child: Container(

              width: MediaQuery.of(context).size.width*0.8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color.fromRGBO(64, 236, 120, 1.0)),borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20,),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:  FittedBox(
                            fit: BoxFit.fill,
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child:
                              Image.asset(
                                'assets/profileImage.jpg',
                              ),
                            )
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(15)),
                            color: Color.fromRGBO(64, 236, 120, 1.0),),
                          width: 23,
                          height: 23,
                          child: Center(
                            child: Text("49", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height:10,),
                  Text("Alex",style: TextStyle(color:  Color.fromRGBO(112, 112, 112, 1.0) ,fontWeight: FontWeight.bold,fontSize: 18),),
                  SizedBox(height:30,),
                  Text("22,34 €",style: TextStyle(color: Color.fromRGBO(112, 112, 112, 1.0), fontWeight: FontWeight.bold, fontSize: 24),)
                  ,SizedBox(height:30,),
                  Text("Bewerte deine Fahrt",style: TextStyle(color: Color.fromRGBO(112, 112, 112, 1.0), fontSize: 16),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.star,color: Color.fromRGBO(255, 185, 0, 1),size: 30,),
                      Icon(Icons.star,color: Color.fromRGBO(255, 185, 0, 1),size: 30,),
                      Icon(Icons.star,color: Color.fromRGBO(255, 185, 0, 1),size: 30,),
                      Icon(Icons.star,color: Color.fromRGBO(255, 185, 0, 1),size: 30,),
                      Icon(Icons.star,color: Color.fromRGBO(70, 78, 99, 1),size: 30,)
                    ],),

                  SizedBox(height:30,),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width*0.6,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, "/");
                      },child: Text("BEWERTUNG ABGEBEN",style: TextStyle(color: Colors.white,fontSize: 13),),color:Color.fromRGBO(64, 236, 120, 1.0),),),
                  SizedBox(height:10,),
                ],),),),


          ]
      ),
    );
  }
}