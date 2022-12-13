import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Thesis {
  final String nameAndSurname;
  final String indexNumber;
  final String recenzentName;
  final String promotorName;
  final String titleInPolish;
  final String titleInEnglish;
  final String yearOfDefense;
  final bool isInz;
  final bool isMgr;
  Thesis(
      {this.nameAndSurname,
      this.recenzentName,
      this.indexNumber,
      this.promotorName,
      this.titleInPolish,
      this.titleInEnglish,
      this.yearOfDefense,
      this.isInz,
      this.isMgr});
}

class Thesies with ChangeNotifier {
  List<Thesis> thesies = [];
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addThesis(
      {String nameAndSurname,
      String recenzentName,
      String indexNumber,
      String promotorName,
      String titleInPolish,
      String titleInEnglish,
      String yearOfDefense,
      bool isInz,
      bool isMgr}) async {
    await thesies.add(Thesis(
        nameAndSurname: nameAndSurname,
        recenzentName: recenzentName,
        indexNumber: indexNumber,
        promotorName: promotorName,
        titleInPolish: titleInPolish,
        titleInEnglish: titleInEnglish,
        yearOfDefense: yearOfDefense,
        isInz: isInz,
        isMgr: isMgr));
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    await firebaseFirestore
        .collection('thesies')
        .doc(user.uid)
        .set(dataToUpdate);
  }

  Future<void> fetchDataFromFirestore() async {
    thesies = [];
    User user = _auth.currentUser;
    try {
      firebaseFirestore.collection('thesies').doc(user.uid).get().then((value) {
        for (var element in value['thesies'] as List) {
          thesies.add(Thesis(
            indexNumber: element['indexNumber'],
            nameAndSurname: element['nameAndSurname'],
            recenzentName: element['recenzentName'],
            promotorName: element['promotorName'],
            titleInPolish: element['titleInPolish'],
            titleInEnglish: element['titleInEnglish'],
            yearOfDefense: element['yearOfDefense'],
            isInz: element['isInz'],
            isMgr: element['isMgr'],
          ));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeThiese(String indexNumber, String titleInPolish) async {
    // await fetchDataFromFirestore();
    await thesies.removeWhere((element) =>
        ((element.indexNumber == indexNumber) &&
            (element.titleInPolish == titleInPolish)));
    User user = _auth.currentUser;
    Map<String, dynamic> dataToUpdate;
    await toMap().then((value) => dataToUpdate = value);
    try {
      await firebaseFirestore
          .collection('thesies')
          .doc(user.uid)
          .update(dataToUpdate);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

//  indexNumber: element['indexNumber'],
//               nameAndSurname: element['nameAndSurname'],
//               recenzentName:element['recenzentName'],
//               promotorName:element['promotorName'],
//               titleInPolish:element['titleInPolish'],
//               titleInEnglish:element['titleInEnglish'],
//               yearOfDefense:element['yearOfDefense'],
  Future<Map<String, dynamic>> toMap() async {
    List<Map<String, dynamic>> dataToReturn = [];
    for (var element in thesies) {
      dataToReturn.add({
        'indexNumber': element.indexNumber,
        'nameAndSurname': element.nameAndSurname,
        'promotorName': element.promotorName,
        'titleInPolish': element.titleInPolish,
        'titleInEnglish': element.titleInEnglish,
        'yearOfDefense': element.yearOfDefense,
        'recenzentName': element.recenzentName,
        'isMgr': element.isMgr,
        'isInz': element.isInz,
      });
    }
    return {'thesies': dataToReturn};
  }

  Future<void> clearData() async {
    thesies = [];
  }
}
