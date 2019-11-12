import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'environment_data/environment.dart';


// This app is a stateful, it tracks the user's current choice.
class PaymentsPage extends StatefulWidget {

  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  String pamentId;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
    SharedPreferences.getInstance().then((res){
      if(res.get("pId") != null){
        setState(() {
          pamentId = res.get("pId");
        });
      }
    });
    StripePayment.setOptions(
        StripeOptions(publishableKey: "pk_test_lWYy2obdjI3mHY9E4vkHAKFR00dgotF0DW", merchantId: "Test", androidPayMode: 'test'));

  }


//  BillingAddress formFiling = BillingAddress(
//    city: currentUserModel.city ?? "Faisalabad",
//    name: currentUserModel.username,
//    country: "pk",
//    line1: "jhal",
//    line2: "chwk",
//    postalCode: "38000",
//    state: "pakistan",
//
//  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: GlobalData.homeScaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text("Bezulhung und Guthaben",style: TextStyle(color: Colors.grey,fontSize: 12.0),),
          backgroundColor: Colors.transparent,
          leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.grey,),
            onPressed:() => Navigator.pop(context, false),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: "BEZAHLUNG",),
              Tab(text: "GUTHABEN",),
            ],
            indicatorColor: Color.fromRGBO(32,110,65,1.0),
            controller: _tabController,
            unselectedLabelColor: Color.fromRGBO(112, 112, 112, 0.3),
            labelColor: Color.fromRGBO(112, 112, 112, 1.0),
            labelStyle: TextStyle(fontSize: 12),
//            labelPadding: EdgeInsets.all(0.0),
          ),
        ),
        body: TabBarView(
          children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: MediaQuery.of(context).size.width,height: 1.0,color: Colors.grey.withOpacity(0.3),),
              ListTile(
                dense: true,
                title: Text(
                  'Deine Bezahloptionen',
                  style: TextStyle(color: Color.fromRGBO(112,112,112,1.0), fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ),
             GestureDetector(child:  Container (
                padding: EdgeInsets.all(5),
                  decoration: new BoxDecoration (
                      color:  Color.fromRGBO(32,110,65,1.0)
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[ Text(
                    'Füge eine Bezahlmethode hinzu um direkt aus der App heraus zu bezahlen (PayPal, Kreditkarte)',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),



                  ),
                    SizedBox(height: 5,),    Text("Bezahlmethode hinzufügen",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),),
                    ],),
              ),
                 onTap:(){
                   containerForSheet<String>(
                     context: context,
                     child: CupertinoActionSheet(
                         title: const Text('Zahlungsmittel hinzufügen',style: TextStyle(fontSize: 13),),
                         actions: <Widget>[
                           CupertinoActionSheetAction(
                             child: const Text('Kreditkarte hinzufügen'),
                             onPressed: pamentId == null ? () {
                               StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
                                 fs.Firestore.instance.collection("cards").document(currentUserModel.id).collection("tokens").add({
                                   "tokenId" : paymentMethod.id,
                                 });
                                 SharedPreferences.getInstance().then((res){
                                   res.setString("pId", paymentMethod.id);
                                   setState(() {
                                     pamentId = paymentMethod.id;
                                   });
                                 });
                                 fs.Firestore.instance.collection("cards").document(currentUserModel.id).setData({
                                   "cust_id" : paymentMethod.customerId,
                                   "email" : currentUserModel.email
                                 });
                               }).catchError(setError);
                               Navigator.pop(context, '🙋 Yes');
                             } : (){
                               Navigator.pop(context, '🙋 Yes');
                               GlobalData.homeScaffoldKey.currentState.showSnackBar(SnackBar(content: Text("You have alreade inserted card")));
                             },
                           ),
                           CupertinoActionSheetAction(
                             child: const Text('PayPal hinzufügen'),
                             onPressed: () {

                               Navigator.pushNamed(context, 'paypal_payment');

                             },
                           ),
                         ],
                         cancelButton: CupertinoActionSheetAction(
                           child: const Text('Abbrechen'),
                           isDefaultAction: true,
                           onPressed: () {
                             Navigator.pop(context, 'Cancel');
                           },
                         )),
                   );
                 }



//                 showTwoItems
//                 (){
////               modal.mainBottomSheet(context);
//             return CupertinoActionSheet(
//               title: Text("Zahlungsmittel hinzufügen",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
//             );
//             },
             ),


              Container(height: 2,color: Colors.white,),

              Container (

                  padding: EdgeInsets.all(5),
                  decoration: new BoxDecoration (
                      color:  Color.fromRGBO(32,110,65,1.0)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text(
                      'Aktiviere automatische Bezahlmethode',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),



                  ),
                      Row(
                        children: <Widget>[
                    Flexible(child:
                    Text("Kreditkarte notwendig (Moober Kredit wird immer zu erst benutzt)",
                        style: TextStyle(color: Colors.white, fontSize: 10.0),)),
                      Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Container(
                                  decoration: new BoxDecoration(
                                    border: new Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white.withOpacity(0.5),
                                  ),alignment: Alignment.bottomCenter,
                                  height: 22,width: 40,
                              ),
                              Switch(
                                onChanged: (v){},
                                value: false,
                                activeColor: Colors.white,
                                activeTrackColor: Colors.transparent,
                                inactiveTrackColor: Colors.transparent,
                              ),
                            ]
                      ),

                        ]
                      )
                    ],
                  )
              ),
              Container(width: MediaQuery.of(context).size.width,height: 0.5,color: Colors.white.withOpacity(0.35),),

              Container (

                  padding: EdgeInsets.all(5),
                  decoration: new BoxDecoration (
                      color:  Color.fromRGBO(32,110,65,1.0)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text(
                      'Aktiviere automatische Guthabennutzung',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),



                  ),Row(children: <Widget>[
                    Flexible(child:
                    Text("Kreditkarte notwendig (Moober Kredit wird immer zu erst benutzt)",
                        style: TextStyle(color: Colors.white, fontSize: 10.0),)),
                      Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                border: new Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                                color: Color.fromRGBO(64, 236, 120, 0.5),
                              ),alignment: Alignment.bottomCenter,
                              height: 22,width: 40,
                            ),
                            Switch(
                              onChanged: (v){},
                              value: false,
                              activeColor: Colors.white,
                              activeTrackColor: Colors.transparent,
                              inactiveTrackColor: Colors.transparent,
                            ),
                          ]
                      ),
                    ])],)
              ),
            ]
          ),
            Column(     crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(width: MediaQuery.of(context).size.width,height: 1.0,color: Colors.grey.withOpacity(0.3),),

                ListTile(
                  dense: true,
                  title: Text(
                    'Dein Guthaben',
                    style: TextStyle(color: Color.fromRGBO(112, 112, 112, 1.0), fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(5),
              decoration: new BoxDecoration (
                  color:  Color.fromRGBO(32,110,65,1.0)
              ),
              child: Column(children: <Widget>[
              Text("0,00€",style: TextStyle(color: Colors.white,fontSize: 22),),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text("Code eingeben",style: TextStyle(color: Colors.white,fontSize: 13),),Text("Zahlungen anzeigen",style: TextStyle(color: Colors.white,fontSize: 13),),],)

              ],),),FlatButton(padding: EdgeInsets.all(10),onPressed:(){Navigator.pushNamed(context, "/guthaben");},child: Text("Gültigkeit",style: TextStyle(color: Colors.grey,fontSize: 12),),)])
          ],
          controller: _tabController,
        ),
      ),
    );
  }
  void setError(dynamic error) {
    print("paymetn error");
    print(error.toString());
//    GlobalData.homeScaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
//    setState(() {
//      _error = error.toString();
//    });
  }
//  final CreditCard testCard = CreditCard(
//    number: '4000002760003184',
//    expMonth: 12,
//    expYear: 21,
//  );
}
void showTwoItems(context){
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context){
      return CupertinoActionSheet(
        title: Text("Two items looks ok"),
        cancelButton: CupertinoActionSheetAction(onPressed: ()=>Navigator.of(context).pop(), child: Text("Cancel")),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Option 1"),
            onPressed: ()=>Navigator.of(context).pop(),
          ),
          CupertinoActionSheetAction(
            child: Text("Option 2"),
            onPressed: ()=>Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

void containerForSheet<T>({BuildContext context, Widget child}) {
  showCupertinoModalPopup<T>(
    context: context,
    builder: (BuildContext context) => child,
  ).then<void>((T value) {
//    GlobalData.homeScaffoldKey.currentState.showSnackBar(new SnackBar(
//      content: new Text('You clicked $value'),
//      duration: Duration(milliseconds: 800),
//    ));
  });
}
