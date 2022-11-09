import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Subject {
  final String title;
  Subject({this.title});
}

class Subjects with ChangeNotifier {
  List<Subject> subjects = [];
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addSubject({String title}) async {
    await subjects.add(Subject(title: title));
    User user = _auth.currentUser;
    await firebaseFirestore.collection('subjects').doc(user.uid).set(toMap());
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
          subjects.add(Subject(title: element['title']));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeSubject(String title) async {
    await fetchDataFromFirestore();
    await subjects.removeWhere((element) => element.title == title);
    User user = _auth.currentUser;
    try {
      await firebaseFirestore
          .collection('subjects')
          .doc(user.uid)
          .update(toMap());
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Map<String, dynamic> toMap() {
    List<Map<String, String>> dataToReturn = [];
    for (var element in subjects) {
      dataToReturn.add({
        'title': element.title,
      });
    }
    return {'subjects': dataToReturn};
  }

  Future<void> clearData() async {
    subjects = [];
  }
}
