import 'package:flutter/material.dart';

// This app is a stateful, it tracks the user's current choice.
class FreundePage extends StatefulWidget {

  @override
  _FreundePageState createState() => _FreundePageState();
}

class _FreundePageState extends State<FreundePage> with SingleTickerProviderStateMixin{


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
          title: Text("Freunde einladen",style: TextStyle(color: Colors.grey,fontSize: 16.0),),
          backgroundColor: Colors.transparent,
          leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.grey,),
            onPressed:() => Navigator.pop(context, false),
          ),

        ),
        body:Container (
      child: Column(
        children: <Widget>[
          Container(height: 2,color: Color.fromRGBO(32,110,65,1.0),),
          Container(
            padding: EdgeInsets.all(15),
            child:Column(children: <Widget>[
              Text("Freunde einladen und profitieren",style: TextStyle(color: Colors.black,fontSize: 18),),
              SizedBox(height: 10.0,),
              Text("Ich möchte News und Rabatte via E-Mail, Push oder"
                    "SMS erhalten. Hierzu werden Standort-, Nutzung- und"
                    "Inhaltsdaten gemäß unserer Datenschutzerklärung"
                    " kombiniert. Die Einwilligung kann ich jederzeit widerrufen.",style: TextStyle(color: Colors.black54),)
            ],
            ),
          ),
    Card(
      child: Container(
//        height: MediaQuery.of(context).size.height*0.2,
        width: MediaQuery.of(context).size.width*0.9,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02),
        child: Column(
          children: <Widget>[
            Text("Dein Einladungscode",textAlign: TextAlign.left,style: TextStyle(fontSize: 16),),
            Text("123eo",textAlign: TextAlign.left,),
            Text("Kopieren",textAlign: TextAlign.left,style: TextStyle(fontSize: 16,color: Color.fromRGBO(32,110,65,1.0))),
            SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            ButtonTheme(
              minWidth: 250.0,
              child:
              RaisedButton(

                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),

                onPressed: () {
//                  Navigator.pushReplacementNamed(context, '/');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color.fromRGBO(32,110,65,1.0),
                child: Text(
                  "Code versenden",
                  textDirection: TextDirection.ltr,
                  style: TextStyle(color: Colors.white,fontSize: 16.0),
                ),
              ),
            )],),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      )
    ),
          SizedBox(height: 15.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[ FlatButton(
            onPressed: () {
//              Navigator.pushReplacementNamed(context, '/Register');
            },
            child: Text(
              "Einladungen (15 verfügbar)",
              textDirection: TextDirection.ltr,
              style: TextStyle(color:Color.fromRGBO(32,110,65,1.0),fontSize: 14.0,fontWeight: FontWeight.bold),
            ),
          ),]),
          FlatButton(
            onPressed: () {
//              Navigator.pushReplacementNamed(context, '/Register');
            },
            child: Text(
              "Hier werden dir zukünftig deine offenen Einladungen angezeigt.",
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Color.fromRGBO(32,110,65,1.0),fontSize: 14.0,fontWeight: FontWeight.bold),
            ),
          ),
  ],
),
           ),

      ),
    );
  }
}
