import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moover/main.dart';
import 'package:moover/widgets/listTileDrives.dart';
import 'package:intl/intl.dart';
// This app is a stateful, it tracks the user's current choice.
class DrivesPage extends StatefulWidget {

  @override
  _DrivesPageState createState() => _DrivesPageState();
}

class _DrivesPageState extends State<DrivesPage> with SingleTickerProviderStateMixin{

  List<DocumentSnapshot> snapShot;
  @override
  void initState() {
    super.initState();
    print("FireStore rides");
    Firestore.instance.collection("rides").reference().where("userId", isEqualTo: currentUserModel.id).getDocuments().then((res){
      print("userID");
      setState(() {
        snapShot = res.documents;
      });
    });
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
          child: Column(
            children: <Widget>[
              Center(child: Text("Verlauf",style: TextStyle(fontSize:12.0,color: Color.fromRGBO(112, 112, 112, 1.0)),),),
              Padding(padding:EdgeInsets.all(3)),
              Container(height: 3,color: Color.fromRGBO(32,110,65,1.0),),
              snapShot == null ? Container(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green),),
              ) : Flexible(
                child: ListView(
                  children:List.generate(snapShot.length, (int index){
                    final f = new DateFormat('yyyy-MM-dd');
                    String format = f.format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapShot[index].data["timestamp"])));
                    String format1 = DateFormat().add_jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapShot[index].data["timestamp"])));
                    return Column(
                      children: <Widget>[
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
                          SizedBox(height: 5,),
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
                              snapShot[index].data["rider"].toString() ?? "",style: TextStyle(color: Color.fromRGBO(32,110,65,1.0),
                          )
                              ,maxLines: 1,
                          ),

                        ],
                  ),

//                  timeTitle: DateTime.fromMillisecondsSinceEpoch(int.parse(snapShot[index].data["timestamp"])).toString(),
                  timeTitle: format.toString() +" " +format1.toString(),
                  first: snapShot[index].data["pickup"]["address"].toString() ?? "",
                  second: snapShot[index].data["destination"]["address"].toString() ?? "",
                ),
              ),
                        Divider()
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
