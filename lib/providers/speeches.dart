import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Speech {
  final String conferenceName;
  final String address;
  final String dateFrom;
  final String dateTo;
  final String speechTitle;
  final String relatedProjectName;
  final List<Map<String, String>> coAuthors;
  Speech(
      {@required this.address,
      @required this.conferenceName,
      @required this.dateFrom,
      @required this.dateTo,
      @required this.speechTitle,
      @required this.relatedProjectName,
      @required this.coAuthors});
}

class Speeches with ChangeNotifier {
  List<Speech> speeches = [];
  final _auth = FirebaseAuth.instance;
  List<Map<String, String>> tempCoWorkers = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<void> addCoWorker(String name, String role) {
    tempCoWorkers.add({"name": name, "role": role});
  }

  Future<void> addSpeech(
      {String address,
      String conferenceName,
      String speechTitle,
      String dateFrom,
      String dateTo,
      String projectName,
      List<Map<String, String>> coAuthors}) async {
    await speeches.add(Speech(
        address: address,
        conferenceName: conferenceName,
        speechTitle: speechTitle,
        dateFrom: dateFrom,
        dateTo: dateTo,
        relatedProjectName: projectName,
        coAuthors: coAuthors));
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    await firebaseFirestore
        .collection('speeches')
        .doc(user.uid)
        .set(dataToUpdate);
  }

  Future<void> fetchDataFromFirestore() async {
    speeches = [];
    User user = _auth.currentUser;
    List<Map<String, String>> coAuthorsToAdd = [];
    try {
      firebaseFirestore
          .collection('speeches')
          .doc(user.uid)
          .get()
          .then((value) {
        for (var element in value['speeches'] as List) {
          coAuthorsToAdd = [];
          for (var author in element["coAuthors"]) {
            coAuthorsToAdd.add({
              'name': author["name"],
              "role": author["role"],
            });
          }

          speeches.add(Speech(
            speechTitle: element["speechTitle"],
            address: element["address"],
            dateTo: element["dateTo"],
            dateFrom: element["dateFrom"],
            conferenceName: element["conferenceName"],
            relatedProjectName: element["projectName"],
            coAuthors: coAuthorsToAdd,
          ));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeSpeach(String speachTitle, String conferenceName) async {
    await fetchDataFromFirestore();
    await speeches.removeWhere((element) =>
        ((element.speechTitle == speachTitle) &&
            (element.conferenceName == conferenceName)));
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    try {
      await firebaseFirestore
          .collection('speeches')
          .doc(user.uid)
          .update(dataToUpdate);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<Map<String, dynamic>> toMap() async {
    List<Map<String, dynamic>> dataToReturn = [];
    for (var element in speeches) {
      dataToReturn.add({
        'address': element.address,
        'speechTitle': element.speechTitle,
        'dateFrom': element.dateFrom,
        'conferenceName': element.conferenceName,
        'dateTo': element.dateTo,
        'projectName': element.relatedProjectName,
        'coAuthors': element.coAuthors,
      });
    }
    return {'speeches': dataToReturn};
  }

  Future<void> clearData() async {
    speeches = [];
  }
}
