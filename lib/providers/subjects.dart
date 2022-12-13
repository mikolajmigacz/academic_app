import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Subject {
  final String code;
  final String name;
  final String semesterNumber;
  final bool isLecture;
  final bool isLabolatories;
  final String hours;
  Subject(
      {this.code,
      this.name,
      this.semesterNumber,
      this.isLecture,
      this.isLabolatories,
      this.hours});
}

class Subjects with ChangeNotifier {
  List<Subject> subjects = [];
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addSubject(
      {String code,
      String name,
      String semesterNumber,
      bool isLecture,
      bool isLabolatories,
      String hours}) async {
    await subjects.add(Subject(
        code: code,
        hours: hours,
        isLabolatories: isLabolatories,
        isLecture: isLecture,
        name: name,
        semesterNumber: semesterNumber));
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    await firebaseFirestore
        .collection('subjects')
        .doc(user.uid)
        .set(dataToUpdate);
  }

  Future<void> fetchDataFromFirestore() async {
    subjects = [];
    User user = _auth.currentUser;
    try {
      firebaseFirestore
          .collection('subjects')
          .doc(user.uid)
          .get()
          .then((value) {
        for (var element in value['subjects'] as List) {
          subjects.add(Subject(
              code: element["code"],
              hours: element["hours"],
              isLabolatories: element["isLabolatories"],
              isLecture: element["isLecture"],
              name: element["name"],
              semesterNumber: element["semesterNumber"]));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeSubject(String code) async {
    await subjects.removeWhere((element) => element.code == code);
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    try {
      await firebaseFirestore
          .collection('subjects')
          .doc(user.uid)
          .update(dataToUpdate);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<Map<String, dynamic>> toMap() async {
    List<Map<String, dynamic>> dataToReturn = [];
    for (var element in subjects) {
      dataToReturn.add({
        'name': element.name,
        'code': element.code,
        'hours': element.hours,
        'isLabolatories': element.isLabolatories,
        'isLecture': element.isLecture,
        'semesterNumber': element.semesterNumber,
      });
    }
    return {'subjects': dataToReturn};
  }

  Future<void> clearData() async {
    subjects = [];
  }
}
