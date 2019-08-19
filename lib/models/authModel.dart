import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../main.dart';

class AuthModel {
  final ref = Firestore.instance.collection('riders');

  Future<bool> checkInternet() async {
    try {
      final result1 = await http
          .read('https://jsonplaceholder.typicode.com/todos/1')
          .timeout(const Duration(seconds: 5));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future signup({email, password}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool check = await checkInternet();
    String message = 'Something went wrong';
    bool successful = false;
    if (check) {
      prefs.setString('email', email);
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        print('start');
        print(user);
        print('start');
        print(user.isEmailVerified);
        if (!user.isEmailVerified) {
          user.sendEmailVerification();
          successful = true;
          prefs.setString('email', email);
          prefs.setString('id', user.uid);
        }
      }).catchError((onError) {
        print("error $onError");

        message = 'The email address is already in use by another account.';
      });
    } else {
      message = 'Kindly check your internet connection!';
    }
    return {'success': successful, 'message': message};
  }

  Future login({email, password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    bool check = await checkInternet();
    String message = 'Something went wrong';
    bool successful = false;
    String userId;

//    if (check) {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      if (user.isEmailVerified) {
        print(user);
        successful = true;
        userId = user.uid;
        prefs.setString("email", email);
        prefs.setString('id', user.uid);
      } else {
        print('failed');
        message = 'Kindly, activate using your email';
      }
    }).catchError((onError) {
      print("error $onError");
      message = 'Invalid email or password';
    });
//    } else {
//      message = 'Kindly check your internet connection!';
//    }
    return {
      'success': successful,
      'message': message,
      "userId": userId,
    };
  }

  Future forgetPassword({email}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    bool check = await checkInternet();
    String message = 'Something went wrong';
    bool successful = false;
    String userId;

//    if (check) {
    await _auth.sendPasswordResetEmail(email: email).then((user) {
      successful = true;
    }).catchError((onError) {
      print("error $onError");
      message = 'Email not found';
    });
//    } else {
//      message = 'Kindly check your internet connection!';
//    }
    return {
      'success': successful,
      'message': message,
    };
  }



  Future registerInfo({userName,  phone,  location,gender,city}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id');
    String email = prefs.getString("email");
    bool check = await checkInternet();
    String message = 'Something went wrong';
    bool successful = false;

//    if (check) {
    try {
      DocumentSnapshot userRecord = await ref.document(userId).get();
      if (userRecord.data == null) {
        // no user record exists, time to create

        if (userName != null || userName.length != 0) {
          ref.document(userId).setData({
            "city":city,
            "created_At": DateTime.now().toString(),
            "id": userId,
            "username": userName,
            "photoUrl":
            "https://img.icons8.com/bubbles/2x/administrator-male.png",
            "email": email,
            "gender": gender,
            "location": location,
            "phone": phone,
            "dob": "",
            "rides": {},
            "currentLocation":{"lat": 51.1657, "long": 10.4515},
            "balance":0.0,
            "active":true,
            "rating":5.0
          });
        }
        userRecord = await ref.document(userId).get();
        successful = true;
        print(userRecord);
      } else {
        message = "User already registered.";
      }


    } catch (e) {
      print(e);
    }
//    } else {
//      message = 'Kindly check your internet connection!';
//    }
    return {'success': successful, 'message': message};
  }
}