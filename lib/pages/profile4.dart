import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This app is a stateful, it tracks the user's current choice.
class Profile4Page extends StatefulWidget {

  @override
  _Profile4PageState createState() => _Profile4PageState();
}

class _Profile4PageState extends State<Profile4Page> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();

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
          title: Text("Mein Adressbuch",style: TextStyle(color: Colors.grey,fontSize: 16.0),),
          backgroundColor: Colors.transparent,
          leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.grey,),
            onPressed:() => Navigator.pop(context, false),
          ),

        ),
        body:Container (



              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(height: 0.5,color: Colors.grey,),
                  SizedBox(height: 20,),
                  Container (

                      padding: EdgeInsets.all(10),


                      child: Column( children: <Widget>[
                        GestureDetector(onTap: (){}, child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                              Text("Zuhause",style: TextStyle(fontSize: 18,color: Color.fromRGBO(32,110,65,1.0),),),
                              Text("Erstelle einen Favoriten für dein Zuhause",style: TextStyle(fontSize: 16,color: Color.fromRGBO(32,110,65,1.0),),)
                            ],),
                            IconButton(icon: Icon(Icons.chevron_right), onPressed: (){})
                          ],
                        )),
                        ])),
                  Container(height: 1,color: Colors.grey,),
                  Expanded(child: Container()),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {},
                      child: Text(
                        "Favoriten hinzufügen",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      color: Color.fromRGBO(32, 110, 65, 1.0),
                    ),),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),


        ),

      ),
    );
  }
}
