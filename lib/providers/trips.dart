import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Trip {
  final String address;
  final String title;
  final String date;
  Trip({this.address, this.title, this.date});
}

class Trips with ChangeNotifier {
  List<Trip> trips = [];
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addTrip({String address, String title, String date}) async {
    await trips.add(Trip(address: address, title: title, date: date));
    User user = _auth.currentUser;
    await firebaseFirestore.collection('trips').doc(user.uid).set(toMap());
  }

  Future<void> fetchDataFromFirestore() async {
    trips = [];
    User user = _auth.currentUser;
    try {
      firebaseFirestore.collection('trips').doc(user.uid).get().then((value) {
        for (var element in value['trips'] as List) {
          trips.add(Trip(
              address: element['address'],
              date: element['date'],
              title: element['title']));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeTrip(String title) async {
    await fetchDataFromFirestore();
    await trips.removeWhere((element) => element.title == title);
    User user = _auth.currentUser;
    try {
      await firebaseFirestore.collection('trips').doc(user.uid).update(toMap());
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Map<String, dynamic> toMap() {
    List<Map<String, String>> dataToReturn = [];
    for (var element in trips) {
      dataToReturn.add({
        'address': element.address,
        'title': element.title,
        'date': element.date
      });
    }
    return {'trips': dataToReturn};
  }

  Future<void> clearData() async {
    trips = [];
  }
}
