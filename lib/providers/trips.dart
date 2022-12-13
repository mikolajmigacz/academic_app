import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Trip {
  final String city;
  final String univeristyName;
  final String dateTo;
  final String dateFrom;
  final String description;
  final String fundName;
  final String relatedProjectName;
  Trip(
      {@required this.city,
      @required this.univeristyName,
      @required this.dateFrom,
      @required this.dateTo,
      @required this.description,
      @required this.fundName,
      @required this.relatedProjectName});
}

class Trips with ChangeNotifier {
  List<Trip> trips = [];
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addTrip(
      {String city,
      String univeristyName,
      String dateFrom,
      String dateTo,
      String description,
      String fundName,
      String relatedProjectName}) async {
    await trips.add(Trip(
        city: city,
        univeristyName: univeristyName,
        dateFrom: dateFrom,
        description: description,
        dateTo: dateTo,
        fundName: fundName,
        relatedProjectName: relatedProjectName));
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    await firebaseFirestore.collection('trips').doc(user.uid).set(dataToUpdate);
  }

  Future<void> fetchDataFromFirestore() async {
    trips = [];
    User user = _auth.currentUser;
    try {
      firebaseFirestore.collection('trips').doc(user.uid).get().then((value) {
        for (var element in value['trips'] as List) {
          trips.add(Trip(
            city: element["city"],
            univeristyName: element["univeristyName"],
            dateTo: element["dateTo"],
            dateFrom: element["dateFrom"],
            description: element["description"],
            fundName: element["fundName"],
            relatedProjectName: element["relatedProjectName"],
          ));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeTrip(String description) async {
    await fetchDataFromFirestore();
    await trips.removeWhere((element) => (element.description == description));
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    try {
      await firebaseFirestore
          .collection('trips')
          .doc(user.uid)
          .update(dataToUpdate);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // city: element["city"],
  //           univeristyName: element["univeristyName"],
  //           dateTo: element["dateTo"],
  //           dateFrom: element["dateFrom"],
  //           description: element["description"],
  //           fundName: element["fundName"],
  //           relatedProjectName: element["relatedProjectName"],

  Future<Map<String, dynamic>> toMap() async {
    List<Map<String, dynamic>> dataToReturn = [];
    for (var element in trips) {
      dataToReturn.add({
        'city': element.city,
        'univeristyName': element.univeristyName,
        'dateFrom': element.dateFrom,
        'description': element.description,
        'dateTo': element.dateTo,
        'fundName': element.fundName,
        'relatedProjectName': element.relatedProjectName,
      });
    }
    return {'trips': dataToReturn};
  }

  Future<void> clearData() async {
    trips = [];
  }
}
