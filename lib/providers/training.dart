import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Training {
  final String title;
  final String address;
  final String certificate;
  final String fundName;
  Training({this.title, this.address, this.certificate, this.fundName});
}

class Trainings with ChangeNotifier {
  List<Training> trainings = [];
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addTraining(
      {String title,
      String address,
      String certificate,
      String fundName}) async {
    await trainings.add(Training(
        title: title,
        address: address,
        certificate: certificate,
        fundName: fundName));
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    await firebaseFirestore
        .collection('trainings')
        .doc(user.uid)
        .set(dataToUpdate);
  }

  Future<void> fetchDataFromFirestore() async {
    trainings = [];
    User user = _auth.currentUser;
    try {
      firebaseFirestore
          .collection('trainings')
          .doc(user.uid)
          .get()
          .then((value) {
        for (var element in value['trainings'] as List) {
          trainings.add(Training(
              address: element['address'],
              title: element['title'],
              certificate: element['certificate'],
              fundName: element['fundName']));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeTraining(String title) async {
    // await fetchDataFromFirestore();
    await trainings.removeWhere((element) => element.title == title);
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    try {
      await firebaseFirestore
          .collection('trainings')
          .doc(user.uid)
          .update(dataToUpdate);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<Map<String, dynamic>> toMap() async {
    List<Map<String, dynamic>> dataToReturn = [];
    for (var element in trainings) {
      dataToReturn.add({
        'address': element.address,
        'title': element.title,
        'certificate': element.certificate,
        'fundName': element.fundName,
      });
    }
    return {'trainings': dataToReturn};
  }

  Future<void> clearData() async {
    trainings = [];
  }
}
