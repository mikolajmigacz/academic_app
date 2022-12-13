import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AboutMe with ChangeNotifier {
  String inz;
  String mgr;
  String hab;
  String prof;
  String experience;
  String education;
  String description;

  AboutMe(
      {this.inz,
      this.mgr,
      this.hab,
      this.prof,
      String experience,
      this.description,
      this.education});

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> saveData() async {
    User user = _auth.currentUser;
    await firebaseFirestore.collection('aboutMe').doc(user.uid).set({
      'inz': inz,
      'mgr': mgr,
      'hab': hab,
      'prof': prof,
      'experience': experience,
      'education': education,
      'description': description
    });
  }

  Future<void> fetchDataFromFirestore() async {
    User user = _auth.currentUser;
    try {
      firebaseFirestore.collection('aboutMe').doc(user.uid).get().then((value) {
        inz = value['inz'];
        mgr = value['mgr'];
        hab = value['hab'];
        prof = value['prof'];
        experience = value['experience'];
        education = value['education'];
        description = value['description'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> clearData() async {
    inz = '';
    mgr = '';
    hab = '';
    prof = '';
    experience = '';
    education = '';
    description = '';
  }
}
