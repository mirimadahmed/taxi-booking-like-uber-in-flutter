import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String id;
  final String photoUrl;
  final String username;
  final Map rides;
  final String location;
  final String phone;
  final String gender;
  final String dob;
  final bool active;
  final Map currentLocation;
  final double balance;
  final double rating;
  final String city;

  const User({
    this.username,
    this.id,
    this.photoUrl,
    this.email,
    this.currentLocation,
    this.balance,
    this.rides,
    this.rating,
    this.location,
    this.phone,
    this.gender,
    this.dob,
    this.active,
    this.city
  });

  factory User.fromDocument(DocumentSnapshot document) {
    print(document);
    return User(
      email: document['email'],
      username: document['username'],
      photoUrl: document['photoUrl'],
      id: document.documentID,
      currentLocation: document['currentLocation'],
      location: document['location'],
      phone: document['phone'],
      rides: document['rides'],
      rating: document['rating'],
      balance: document['balance'],
      gender: document["gender"],
      dob: document["dob"],
      active: document['active'],
      city: document['city'],
    );
  }
  factory User.fromMap(Map document) {
    return User(
      email: document['email'],
      username: document['username'],
      photoUrl: document['photoUrl'],
      id: document['id'],
      currentLocation: document['currentLocation'],
      location: document['location'],
      phone: document['phone'],
      rides: document['rides'],
      rating: document['rating'],
      balance: document['balance'],
      gender: document["gender"],
      dob: document["dob"],
      active: document['active'],

      city: document['city'],
    );
  }
}
