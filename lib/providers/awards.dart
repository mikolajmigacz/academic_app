import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Award {
  final String name;
  final String date;
  final String place;

  Award({
    this.name,
    this.date,
    this.place,
  });
}

class Awards with ChangeNotifier {
  List<Award> awards = [];
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addAward({
    String name,
    String date,
    String place,
  }) async {
    await awards.add(Award(
      date: date,
      name: name,
      place: place,
    ));
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    await firebaseFirestore
        .collection('awards')
        .doc(user.uid)
        .set(dataToUpdate);
  }

  Future<void> fetchDataFromFirestore() async {
    awards = [];
    User user = _auth.currentUser;
    try {
      firebaseFirestore.collection('awards').doc(user.uid).get().then((value) {
        for (var element in value['awards'] as List) {
          awards.add(Award(
            name: element['name'],
            date: element['date'],
            place: element['place'],
          ));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeAward(String name) async {
    // await fetchDataFromFirestore();
    await awards.removeWhere((element) => element.name == name);
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    try {
      await firebaseFirestore
          .collection('awards')
          .doc(user.uid)
          .update(dataToUpdate);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<Map<String, dynamic>> toMap() async {
    List<Map<String, dynamic>> dataToReturn = [];
    for (var element in awards) {
      dataToReturn.add({
        'name': element.name,
        'date': element.date,
        'place': element.place,
      });
    }
    return {'awards': dataToReturn};
  }

  Future<void> clearData() async {
    awards = [];
  }
}
