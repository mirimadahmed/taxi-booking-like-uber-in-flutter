import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moover/widgets/listTileDrives.dart';

// This app is a stateful, it tracks the user's current choice.
class DrivesPage extends StatefulWidget {

  @override
  _DrivesPageState createState() => _DrivesPageState();
}

class _DrivesPageState extends State<DrivesPage> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text("Deine Fahrten",style: TextStyle(color: Colors.grey,fontSize: 16.0),),
//          centerTitle:,
          backgroundColor: Colors.transparent,
          leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.grey,),
            onPressed:() => Navigator.pop(context, false),
          ),

        ),
        body:Container (

          child: ListView(

            children: <Widget>[
              Center(child: Text("Verlauf",style: TextStyle(fontSize:12.0,color: Color.fromRGBO(112, 112, 112, 1.0)),),),
              Padding(padding:EdgeInsets.all(3)),
              Container(height: 3,color: Color.fromRGBO(32,110,65,1.0),),

              GestureDetector(
                    onTap: (){
                    Navigator.pushNamed(context, "/profile");
                  },
                child: CustomListItem(
                  thumbnail: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "5,55 €",style: TextStyle(color: Color.fromRGBO(32,110,65,1.0)),
                      ),
                      SizedBox(height: 20,),
                      Container(
                          width: 60.00,
                          height: 60.00,
//                              margin: EdgeInsets.only(top: 50.0,left: 20),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: new DecorationImage(
                              image: ExactAssetImage('assets/profileImage.jpg'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          child: Container(child: Image.asset("assets/rating.png"),alignment: Alignment.bottomRight,)
                      ),
                      SizedBox(height: 5,),
                      Text(
                          "Alex",style: TextStyle(color: Color.fromRGBO(32,110,65,1.0))
                      ),

                    ],
                  ),
                  timeTitle: "23.05.2019, 03:47",
                  first: "Maximiliansplatz 5, 80333 München",
                  second: "Maximiliansplatz 5, 80333 München",
                ),
              ),
              Container(width: MediaQuery.of(context).size.width,color: Color.fromRGBO(112, 112, 112, 0.3),height: 1.0,),

              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, "/profile");
                },
                child: CustomListItem(
                  thumbnail: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "5,55 €",style: TextStyle(color: Color.fromRGBO(32,110,65,1.0)),
                      ),
                      SizedBox(height: 20,),
                      Container(
                          width: 60.00,
                          height: 60.00,
//                              margin: EdgeInsets.only(top: 50.0,left: 20),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: new DecorationImage(
                              image: ExactAssetImage('assets/profileImage.jpg'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          child: Container(child: Image.asset("assets/rating.png"),alignment: Alignment.bottomRight,)
                      ),
                      SizedBox(height: 5,),
                      Text(
                          "Alex",style: TextStyle(color: Color.fromRGBO(32,110,65,1.0))
                      ),

                    ],
                  ),
                  timeTitle: "23.05.2019, 03:47",
                  first: "Maximiliansplatz 5, 80333 München",
                  second: "Maximiliansplatz 5, 80333 München",
                ),
              ),
              Container(width: MediaQuery.of(context).size.width,color: Color.fromRGBO(112, 112, 112, 0.3),height: 1.0,),

              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, "/profile");
                },
                child: CustomListItem(
                  thumbnail: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "5,55 €",style: TextStyle(color: Color.fromRGBO(32,110,65,1.0)),
                      ),
                      SizedBox(height: 20,),
                      Container(
                          width: 60.00,
                          height: 60.00,
//                              margin: EdgeInsets.only(top: 50.0,left: 20),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: new DecorationImage(
                              image: ExactAssetImage('assets/profileImage.jpg'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          child: Container(child: Image.asset("assets/rating.png"),alignment: Alignment.bottomRight,)
                      ),
                      SizedBox(height: 5,),
                      Text(
                          "Alex",style: TextStyle(color: Color.fromRGBO(32,110,65,1.0))
                      ),

                    ],
                  ),
                  timeTitle: "23.05.2019, 03:47",
                  first: "Maximiliansplatz 5, 80333 München",
                  second: "Maximiliansplatz 5, 80333 München",
                ),
              ),
              Container(width: MediaQuery.of(context).size.width,color: Color.fromRGBO(112, 112, 112, 0.3),height: 1.0,)

            ],
          ),

        ),

      ),
    );
  }
}
