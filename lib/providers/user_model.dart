import 'dart:async';

import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String uid;
  String email;
  String firstName;
  String surname;
  String city;

  UserModel({this.uid, this.email, this.firstName, this.surname, this.city});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
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
}
