import 'package:flutter/material.dart';

// This app is a stateful, it tracks the user's current choice.
class GuthabenPage extends StatefulWidget {

  @override
  _GuthabenPageState createState() => _GuthabenPageState();
}

class _GuthabenPageState extends State<GuthabenPage> with SingleTickerProviderStateMixin{


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
          title: Text("Guthaben einlösen",style: TextStyle(color: Colors.grey,fontSize: 16.0),),
          backgroundColor: Colors.transparent,
          leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.grey,),
            onPressed:() => Navigator.pop(context, false),
          ),

        ),
        body:Container (


    child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(height: 0.5,color: Colors.grey,),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Guthaben-Code',
                      style: TextStyle(color: Color.fromRGBO(112, 112, 112, 1.0), fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),

            Container(
                padding: EdgeInsets.all(10),
                child:TextField(decoration: InputDecoration(hintText: "Guthaben-Code eingeben"),)),


                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    FlatButton(onPressed:(){Navigator.pushNamed(context, "/veralauf");},child: Text("Guthaben aufladen",style: TextStyle(color:
                  Color.fromRGBO(32,110,65,1.0),fontSize: 18,fontWeight: FontWeight.w600),),)
                  ],)

                ]
            )),

      ),
    );
  }
}
