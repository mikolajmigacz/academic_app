import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Speech {
  final String address;
  final String title;
  final String date;
  Speech({this.address, this.title, this.date});
}

class Speeches with ChangeNotifier {
  List<Speech> speeches = [];
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addSpeech({String address, String title, String date}) async {
    await speeches.add(Speech(address: address, title: title, date: date));
    User user = _auth.currentUser;
    await firebaseFirestore.collection('speeches').doc(user.uid).set(toMap());
  }

  Future<void> fetchDataFromFirestore() async {
    speeches = [];
    User user = _auth.currentUser;
    try {
      firebaseFirestore
          .collection('speeches')
          .doc(user.uid)
          .get()
          .then((value) {
        for (var element in value['speeches'] as List) {
          speeches.add(Speech(
              address: element['address'],
              date: element['date'],
              title: element['title']));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeSpeach(String title) async {
    await fetchDataFromFirestore();
    await speeches.removeWhere((element) => element.title == title);
    User user = _auth.currentUser;
    try {
      await firebaseFirestore
          .collection('speeches')
          .doc(user.uid)
          .update(toMap());
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Map<String, dynamic> toMap() {
    List<Map<String, String>> dataToReturn = [];
    for (var element in speeches) {
      dataToReturn.add({
        'address': element.address,
        'title': element.title,
        'date': element.date
      });
    }
    return {'speeches': dataToReturn};
  }

  Future<void> clearData() async {
    speeches = [];
  }
}
