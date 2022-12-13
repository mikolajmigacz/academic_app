import 'dart:convert';

import 'package:academic_app/providers/about_me.dart';
import 'package:academic_app/providers/awards.dart';
import 'package:academic_app/providers/projects.dart';
import 'package:academic_app/providers/speeches.dart';
import 'package:academic_app/providers/subjects.dart';
import 'package:academic_app/providers/training.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/thesis.dart';
import '../providers/trips.dart';
import '../providers/user_data.dart';
import '../providers/scopus.dart';
import '../shared/constants.dart';
import './home_page.dart';
import './register_page.dart';
import './splash_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isLoading = false;
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserData>(context);
    var scopusData = Provider.of<Scopus>(context);
    var speechesData = Provider.of<Speeches>(context);
    var tripsData = Provider.of<Trips>(context);
    var subjectsData = Provider.of<Subjects>(context);
    var thesiesData = Provider.of<Thesies>(context);
    var projectsData = Provider.of<Projects>(context);
    var trainingsData = Provider.of<Trainings>(context);
    var awardsData = Provider.of<Awards>(context);
    var aboutMeData = Provider.of<AboutMe>(context);
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Constants.primaryColor,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(
                emailController.text,
                passwordController.text,
                userData,
                scopusData,
                speechesData,
                tripsData,
                subjectsData,
                thesiesData,
                projectsData,
                trainingsData,
                awardsData,
                aboutMeData);
          },
          child: const Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              height: 200,
                              child: Image.asset(
                                "assets/images/logo_with_letters.png",
                                fit: BoxFit.contain,
                              )),
                          const SizedBox(height: 45),
                          emailField,
                          const SizedBox(height: 25),
                          passwordField,
                          const SizedBox(height: 35),
                          loginButton,
                          const SizedBox(height: 15),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Don't have an account? "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationScreen()));
                                  },
                                  child: Text(
                                    "Register here",
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                )
                              ])
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(
      String email,
      String password,
      UserData userData,
      Scopus scopusData,
      Speeches speechesData,
      Trips tripsData,
      Subjects subjectsData,
      Thesies thesiesData,
      Projects projectsData,
      Trainings trainingsData,
      Awards awardsData,
      AboutMe aboutMeData) async {
    if (_formKey.currentState.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) async {
          await getDetailsFromFirestore(
                  uid.user.uid,
                  userData,
                  scopusData,
                  speechesData,
                  tripsData,
                  subjectsData,
                  thesiesData,
                  projectsData,
                  trainingsData,
                  awardsData,
                  aboutMeData)
              .then((value) {
            Fluttertoast.showToast(msg: "Login Successful");
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
          });
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage);
        print(error.code);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> getDetailsFromFirestore(
      String uid,
      UserData globalUserData,
      Scopus scopusData,
      Speeches speechesData,
      Trips tripsData,
      Subjects subjectsData,
      Thesies thesiesData,
      Projects projectsData,
      Trainings trainingsData,
      Awards awardsData,
      AboutMe aboutMeData) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      globalUserData.firstName = value['firstName'];
      globalUserData.uid = value['uid'];
      globalUserData.surname = value['surname'];
      globalUserData.email = value['email'];
      globalUserData.city = value['city'];
    });
    await FirebaseFirestore.instance
        .collection("scopus")
        .doc(uid)
        .get()
        .then((value) {
      scopusData.authorId = value['authorId'];
      scopusData.orcid = value['orcid'];
      scopusData.scopusProfileLink = value['scopusProfileLink'];
      scopusData.universityName = value['universityName'];
      scopusData.hirischIndex = int.parse(value['hirischIndex']);
      scopusData.createdDocuments = [];
      for (var element in (value['createdDocuments'] as List)) {
        scopusData.createdDocuments.add({
          'citedByCount': element['citedByCount'],
          'creator': element['creator'],
          'dateOfCreation': element['dateOfCreation'],
          'link': element['link'],
          'title': element['title'],
          'publicationName': element['publicationName'],
        });
      }
    });
    await scopusData.caluclateCitationsAmount();
    await speechesData.fetchDataFromFirestore();
    await tripsData.fetchDataFromFirestore();
    await subjectsData.fetchDataFromFirestore();
    await thesiesData.fetchDataFromFirestore();
    await projectsData.fetchDataFromFirestore();
    await trainingsData.fetchDataFromFirestore();
    await awardsData.fetchDataFromFirestore();
    await aboutMeData.fetchDataFromFirestore();
  }
}
