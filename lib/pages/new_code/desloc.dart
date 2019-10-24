import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moover/pages/environment_data/environment.dart';

class DestLoca extends StatefulWidget {
  @override
  _DestLocaState createState() => _DestLocaState();
}

class _DestLocaState extends State<DestLoca> {

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      right: false,
      left: false,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                myLocationEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
