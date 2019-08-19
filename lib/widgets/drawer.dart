import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DrawerWidgetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return drawerWidgetPageState();
  }
}

class drawerWidgetPageState extends State<DrawerWidgetPage>{

  bool folder = false,parameters= false, gestion=false, gestion1=false;

  @override
  Widget build(BuildContext context) {
    return Drawer(


      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX:500 ,sigmaY: 5),
        child: Container(
//          padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 15.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(

//                  stops: [ 0.0,1.0],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Color.fromRGBO(32, 110, 65, 1),
                    Color.fromRGBO(32, 110, 65, 1),
//                    Color.fromRGBO(78,94,208, 1.0),
                  ])),
          child: ListView(
            children: <Widget>[
          Stack(
          children: <Widget>[
            Image.asset("assets/carShadeDrawer.png"),

            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 80.00,
                    height: 80.00,
                    margin: EdgeInsets.only(top: 50.0,left: 20),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/profileImage.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    child: Container(height: 20,width: 20,child: Image.asset("assets/rating.png"),alignment: Alignment.bottomRight,)
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Mikey Mechito',
                        style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '@mechitomike',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )

//            Container(
//              height: 100.0,
//                width: 100.0,
//                margin: EdgeInsets.only(top: 50.0,left: 20),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                ClipRRect(
//                        borderRadius: new BorderRadius.circular(8.0),
//                      child: Stack(
//                        children: <Widget>[
//                          Image.asset("assets/carShadeDrawer.png"),
//                        ],
//                      )
//                ),
//                    Padding(
//                      padding: EdgeInsets.only(top: 20.0, left: 10.0),
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text(
//                            'Mikey Mechito',
//                            style: TextStyle(
//                                fontSize: 14.0,
//                                color: Colors.white,
//                                fontWeight: FontWeight.bold),
//                          ),
//                          Text(
//                            '@mechitomike',
//                            style: TextStyle(
//                              fontSize: 12.0,
//                              color: Colors.white,
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ],
//                )
//            ),
          ]
          ),
Container(color: Colors.grey[300],height: 8,),
          Container(
             padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: Text("Guthaben: 25,00€ Status: Gold-Status",style: TextStyle(color: Colors.white),
            ),
          ),

          Container(color: Colors.white,height: 2,),

              Container(
                child: ListTile(
                  dense: true,
                  title: Text(
                    'Deine Fahrten',
                    style: TextStyle(color: Colors.white, fontSize: 11.0),
                  ),
                  leading: Image.asset('assets/home.png',color: Colors.white,height: 20,width:20.0,fit: BoxFit.fill,),
//                                selected: _index == 1,
                  onTap: () async {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pushNamed(context, '/rides');
                  },
                ),
              ),
              Container(
                child: ListTile(
                  dense: true,
                  title: Text(
                    'Freunde einladen',
                    style: TextStyle(color: Colors.white, fontSize: 11.0),
                  ),
                  leading: Image.asset('assets/calender1.png',color: Colors.white,height: 20,),
//                        trailing: Icon(
//                            folder
//                                ? Icons.keyboard_arrow_up
//                                : Icons.keyboard_arrow_down,
//                            color: Colors.white,
//                            size: 20.0),

//                                selected: _index == 1,
                  onTap: () async {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pushNamed(context, "/friend");
                  },
                ),
              ),
              !folder
                  ? Container()
                  : Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 60.0),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        'ADD NEW FOLDER',
                        style: TextStyle(
                            color: Colors.white, fontSize: 11.0),
                      ),
//                                selected: _index == 1,
                      onTap: () async {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pushNamed(context, '/addFolder');
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 60.0),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        'VIEW FOLDER',
                        style: TextStyle(
                            color: Colors.white, fontSize: 11.0),
                      ),
//                      leading: Icon(Icons.insert_drive_file,
//                          color: Colors.white, size: 30.0),
//                      trailing: IconButton(icon: Icon(Icons.keyboard_arrow_down,
//                          color: Colors.white, size: 30.0), onPressed: (){

//                      }),
//                                selected: _index == 1,
                      onTap: () async {

                        Navigator.pushNamed(context,'/showFolder');
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                      },
                    ),
                  ),
                ],
              ),
              Container(
                child: ListTile(
                  dense: true,
                  title: Text(
                    'Bezahlung',
                    style: TextStyle(color: Colors.white, fontSize: 11.0),
                  ),
                  leading:Image.asset('assets/cash1.png',color: Colors.white,height: 20,width:20.0,fit: BoxFit.fill,),
//                  trailing: Icon(Icons.keyboard_arrow_down,
//                      color: Colors.white, size: 30.0),
//                                selected: _index == 1,
                  onTap: () async {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pushNamed(context, '/payments');
                  },
                ),
              ),
              Container(
                child: ListTile(
                  dense: true,
                  title: Text(
                    'Profil',
                    style: TextStyle(color: Colors.white, fontSize: 11.0),
                  ),
                  leading: Image.asset('assets/profile1.png',color: Colors.white,height: 20,width:20.0,fit: BoxFit.fill,),
//                          trailing: Icon(
//                              gestion
//                                  ? Icons.keyboard_arrow_up
//                                  : Icons.keyboard_arrow_down,
//                              color: Colors.white,
//                              size: 20.0),
////                                selected: _index == 1,
                  onTap: () async {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pushNamed(context, "/profile");

                  },
                ),
              ),

              Container(
                child: ListTile(
                  dense: true,
                  title: Text(
                    'Angebote',
                    style: TextStyle(color: Colors.white, fontSize: 11.0),
                  ),
                  leading: Image.asset('assets/info1.png',color: Colors.white,height: 20,width: 20.0,fit: BoxFit.fill,),
//                  trailing: Icon(Icons.,
//                      color: Colors.white, size: 30.0),
//                                selected: _index == 1,
                  onTap: () async {
                    Navigator.pushNamed(context, '/constat');
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                  },
                ),
              ),
              Container(
                child: ListTile(
                  dense: true,
                  title: Text(
                    'Privacy',
                    style: TextStyle(color: Colors.white, fontSize: 11.0),
                  ),
                  leading:
                  Icon(Icons.beenhere, color: Colors.white, size: 20.0),
//                        trailing: Icon(
//                            parameters
//                                ? Icons.keyboard_arrow_up
//                                :
//                            Icons.keyboard_arrow_down,
//                            color: Colors.white, size: 20.0),

//                                selected: _index == 1,
                  onTap: () async {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    setState(() {
                    });
                  },
                ),
              ),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 60.0),
                    child: FlatButton(

                      child: Text(
                        'Support und FAQ',
                        style: TextStyle(
                            color: Colors.white, fontSize: 12.0),
                      ),
//                                selected: _index == 1,
                      onPressed: () async {


                        // Update the state
                        //of the app
                        // ...
                        // Then close the drawer
                      },
                    ),
                  ), Container(
                    padding: EdgeInsets.only(left: 60.0),
                    child: FlatButton(

                      child: Text(
                        'Über Moober',
                        style: TextStyle(
                            color: Colors.white, fontSize: 12.0),
                      ),
//                                selected: _index == 1,
                      onPressed: () async {


                        // Update the state
                        //of the app
                        // ...
                        // Then close the drawer
                      },
                    ),
                  ), Container(
                    padding: EdgeInsets.only(left: 60.0),
                    child: FlatButton(

                      child: Text(
                        'Jobs',
                        style: TextStyle(
                            color: Colors.white, fontSize: 12.0),
                      ),
//                                selected: _index == 1,
                      onPressed: () async {


                        // Update the state
                        //of the app
                        // ...
                        // Then close the drawer
                      },
                    ),
                  ),
                ],
              ),
              Container(
                child: ListTile(
                  dense: true,
                  title: Text(
                    'Ausloggen',
                    style: TextStyle(color: Colors.white, fontSize: 11.0),
                  ),
                  leading: Icon(Icons.input, color: Colors.white, size: 20.0),
//                        trailing: Icon(
//                            gestion1
//                                ? Icons.keyboard_arrow_up
//                                : Icons.keyboard_arrow_down,
//                            color: Colors.white,
//                            size: 20.0),
////                                  selected: _index == 1,
                  onTap: () async {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    setState(() {
                      gestion1 = gestion1 ? false : true;
                    });

                  },
                ),
              ),
              !gestion1
                  ? Container()
                  : Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 60.0),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        'AJOUUTER UN NOVEL UTILISTEURS',
                        style: TextStyle(
                            color: Colors.white, fontSize: 11.0),
                      ),
//                                selected: _index == 1,
                      onTap: () async {

                        Navigator.pushNamed(context,'/noval');
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 60.0),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        'GESTION DES AUTORISATIONS D\'ACCESS',
                        style: TextStyle(
                            color: Colors.white, fontSize: 11.0),
                      ),
//                                selected: _index == 1,
                      onTap: () async {

                        Navigator.pushNamed(context,'/gestion');
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),




    );
  }
}