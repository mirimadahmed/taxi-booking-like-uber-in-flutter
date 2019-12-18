import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  DatabaseReference itemRef;
  List<DriverOfFinishedRide> items = List();
  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase.instance;
    print("driver id" + currentUserModel.id);
    itemRef = database.reference().child('finished');

    itemRef.onChildAdded.listen(_onEntryAdded);
  }

  _onEntryAdded(Event event) {
    if(event.snapshot.value["userId"] == currentUserModel.id){
      print(event.snapshot.value["userId"]);
      setState(() {
        items.add(DriverOfFinishedRide.fromSnapshot(event.snapshot));
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.grey,), onPressed: (){
          Navigator.of(context).pop();
        }),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("History",style: TextStyle(color: Colors.grey),),
//        shape: Border(bottom: BorderSide(width: 2, color: Colors.green)),
      ),
      body: Container(

        child: Column(
            children: <Widget>[
              Container( height: 0.5,color: Colors.black,),

              Expanded(child:  ListView(
                  children: List.generate(items.length, (int index){
                    final f = new DateFormat('yyyy-MM-dd');
                    String format = f.format(DateTime.fromMillisecondsSinceEpoch(int.parse(items[index].date)));
                    String format1 = DateFormat().add_jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(items[index].date)));
                    return Container(
                      width: w,
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(format.toString() +" " +format1.toString(), style: TextStyle(color: Color.fromRGBO(26, 124, 26, 1.0)),),
                              Text(items[index].amount + "€", style: TextStyle(color: Color.fromRGBO(26, 124, 26, 1.0)),overflow: TextOverflow.fade,),
                            ],
                          ),
                          Row(children: <Widget>[
                            Icon(Icons.location_on, color: Colors.green,),
                            Text("Location pickup:"),
                          ],),
                          Text(items[index].pickup ?? "", style: TextStyle(color: Color.fromRGBO(26, 124, 26, 1.0)),overflow: TextOverflow.fade,),
                          Row(children: <Widget>[
                            Icon(Icons.location_off, color: Colors.green,),
                            Text("Location Destination:"),
                          ],),
                          Text(items[index].dest ?? "", style: TextStyle(color: Color.fromRGBO(26, 124, 26, 1.0)),overflow: TextOverflow.fade,),
                        ],
                      ),
                    );
                  })
              ))]),
      ),
    );
  }
}


class DriverOfFinishedRide{
  final String date;
  final String amount;
  final String pickup;
  final String dest;
  DriverOfFinishedRide(this.date,this.amount,this.dest,this.pickup);
  DriverOfFinishedRide.fromSnapshot(DataSnapshot snapshot)
      : date = snapshot.value["timestamp"],
        amount = snapshot.value["amount"],
        pickup = snapshot.value["pAdderss"],
        dest = snapshot.value["dAdderss"];
}














//Align(
//alignment: Alignment.centerRight,
//child: Column(
//children: <Widget>[
//Stack(
//children: [
//ClipRRect(
//borderRadius: BorderRadius.circular(15),
//child:  FittedBox(
//fit: BoxFit.fill,
//child: SizedBox(
//width: 60,
//height: 60,
//child:
//Image.asset(
//'assets/profileImage.jpg',
//),
//)
//),
//),
//Positioned(
//right: 0,
//bottom: 0,
//child: Container(
//decoration: BoxDecoration(
//borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(15)),
//color: Color.fromRGBO(64, 236, 120, 1.0),),
//width: 23,
//height: 23,
//child: Center(
//child: Text("49", style: TextStyle(color: Colors.white)),
//),
//),
//)
//],
//),
//Text("Alex",style: TextStyle(color: Color.fromRGBO(26, 124, 26, 1.0), fontWeight: FontWeight.bold),),
//],
//),
//),

