import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moover/pages/drives.dart';
import 'package:moover/pages/payment.dart';
import 'package:moover/pages/profile.dart';
import 'package:moover/pages/profile1.dart';
import 'package:moover/pages/profile2.dart';
import 'package:moover/pages/profile3.dart';
import 'package:moover/pages/standardscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/Guthaben.dart';
import './pages/dashboard.dart';
import 'package:moover/pages/auth/login.dart';
import './pages/Verlauf.dart';
import './pages/Feunde.dart';
import './pages/profile4.dart';
import './pages/auth/signup.dart';
import './pages/searchPage.dart';
import './pages/confirmDestination.dart';
import './pages/confirmPickup.dart';
import './pages/ChooseTransport.dart';
import './pages/confirm.dart';
import './pages/placeOrder.dart';
import './pages/contactDriver.dart';
import './pages/rate.dart';
import './pages/auth/register.dart';
import './models/userModel.dart';
import 'pages/get_reset_link.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:async';
import 'pages/paypal_payment.dart';




const kGoogleApiKey = "AIzaSyB81xMeMewP3-P3KyUloVMJnvVEhgfHgrI";

GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

final searchScaffoldKey = GlobalKey<ScaffoldState>();



void main() {
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//      .then((_) {
//    debugPaintSizeEnabled = false;
//  });
  runApp(MyApp());
}
User currentUserModel = new User();

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  String id;
  var varifiedemail;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs){
      setState((){
        id = prefs.get("id");
        varifiedemail = prefs.get("emailverified");
        if(prefs.get("user") != null)
        currentUserModel =  User.fromMap(jsonDecode(prefs.getString("user")));
        print("currentUserModel");
        print(currentUserModel.username);
      });
    });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    Router router = Router();
    router.define('/profile', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ProfilePage();
    }));
    router.define('/rate', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return RatePage();
    }));
    router.define('/profile1', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return Profile1Page();
    }));
    router.define('/profile2', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return Profile2Page();
    }));
    router.define('/profile3', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return Profile3Page();
    }));
    router.define('/profile4', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ZuhausePage();
    }));
    router.define('/rides', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return HistoryPage();
    }));
    router.define('/', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return
       (id != null && varifiedemail != null) ? StandardScreenPage() : Login();
    }));
    router.define('/register', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return Register();
    }));
    router.define('/signup', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return SignUp();
    }));
    router.define('/guthaben', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return GuthabenPage();
    }));
    router.define('/search', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return SearchPage();
    }));
    router.define('/destination', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ConfirmDestination();
    }));
    router.define('/transport', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ChooseTransportPage();
    }));
    router.define('/pickup', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ConfirmPickup();
    }));
    router.define('/confirm', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ConfirmPage();
    }));
    router.define('/place', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return PlaceOrderPage();
    }));
    router.define('/contact', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return contactDriverPage();
    }));
    router.define('/veralauf', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return VerlaufPage();
    }));
    router.define('/friend', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return FreundePage();
//=======
//      return Profile3Page();
//>>>>>>> ef991136e0f6f2ca2f2266e2215e30f2278cbe3f
    }));
    router.define('/dashboard/:index', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return Dashboard();
    }));
    router.define('/Dashboard', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return StandardScreenPage();
    }));
    router.define('/payments', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return PaymentsPage();
    }));
    router.define('/forget-password', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return GetResetLink();
        }));

    router.define('/paypal_payment', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return PayPalPayment();
        }));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
//        home: ChooseTransportPage(),
        theme: ThemeData(
          hintColor: Colors.grey,
          primaryColor: Colors.grey[100],
          accentColor: Colors.grey,
          fontFamily: 'Gibson-Regular',
          textTheme: TextTheme(body1: TextStyle(fontSize: 16.0)),
        ),
        onGenerateRoute: router.generator,
    );
  }
}
