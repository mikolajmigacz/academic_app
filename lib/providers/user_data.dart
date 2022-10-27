import 'dart:async';

import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  String uid;
  String email;
  String firstName;
  String surname;
  String city;

  UserData({this.uid, this.email, this.firstName, this.surname, this.city});

  // receiving data from server
  factory UserData.fromMap(map) {
    return UserData(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      surname: map['secondName'],
      city: map['city'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'surname': surname,
      'city': city,
    };
  }

  void clearData() {
    uid = null;
    email = null;
    firstName = null;
    surname = null;
    city = null;
  }

  bool isDataReady() {
    if (uid != null &&
        email != null &&
        firstName != null &&
        surname != null &&
        city != null) {
      return true;
    }
    return false;
  }
}
