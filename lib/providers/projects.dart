import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Project {
  final String title;
  final String foundSource;
  final String dateFrom;
  final String dateTo;
  final String competitionName;
  final String roleName;
  final bool isInternational;
  final List<Map<String, String>> coAuthors;

  Project({
    this.title,
    this.foundSource,
    this.dateFrom,
    this.dateTo,
    this.roleName,
    this.competitionName,
    this.isInternational,
    this.coAuthors,
  });
}

class Projects with ChangeNotifier {
  List<Project> projects = [];
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, String>> tempCoWorkers = [];
  Future<void> addCoWorker(String name, String role) {
    tempCoWorkers.add({"name": name, "role": role});
  }

  Future<void> addProject(
      {String title,
      String foundSource,
      String dateFrom,
      String dateTo,
      String competitionName,
      String roleName,
      bool isInternational,
      List<Map<String, String>> coAuthors}) async {
    await projects.add(Project(
      title: title,
      foundSource: foundSource,
      dateFrom: dateFrom,
      dateTo: dateTo,
      competitionName: competitionName,
      roleName: roleName,
      isInternational: isInternational,
      coAuthors: coAuthors,
    ));
    User user = _auth.currentUser;
    await firebaseFirestore.collection('projects').doc(user.uid).set(toMap());
  }

  Future<void> fetchDataFromFirestore() async {
    projects = [];
    User user = _auth.currentUser;
    List<Map<String, String>> coAuthorsToAdd = [];
    try {
      firebaseFirestore
          .collection('projects')
          .doc(user.uid)
          .get()
          .then((value) {
        for (var element in value['projects'] as List) {
          coAuthorsToAdd = [];
          for (var author in element["coAuthors"]) {
            coAuthorsToAdd.add({
              'name': author["name"],
              "role": author["role"],
            });
          }

          projects.add(Project(
            title: element["title"],
            foundSource: element["foundSource"],
            dateTo: element["dateTo"],
            dateFrom: element["dateFrom"],
            competitionName: element["competitionName"],
            roleName: element["roleName"],
            isInternational: element["isInternational"],
            coAuthors: coAuthorsToAdd,
          ));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeProject(String title) async {
    await fetchDataFromFirestore();
    await projects.removeWhere((element) => element.title == title);
    User user = _auth.currentUser;
    try {
      await firebaseFirestore
          .collection('projects')
          .doc(user.uid)
          .update(toMap());
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> dataToReturn = [];
    for (var element in projects) {
      dataToReturn.add({
        "title": element.title,
        "foundSource": element.foundSource,
        "dateTo": element.dateTo,
        "dateFrom": element.dateFrom,
        "competitionName": element.competitionName,
        "roleName": element.roleName,
        "isInternational": element.isInternational,
        "coAuthors": element.coAuthors,
      });
    }
    return {'projects': dataToReturn};
  }

  Future<void> clearData() async {
    projects = [];
  }
}
