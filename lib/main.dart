import 'dart:convert';

import 'package:academic_app/providers/scopus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './shared/constants.dart';
import './pages/home_page.dart';
import './pages/projects_page.dart';
import './pages/login_page.dart';
import 'providers/user_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserData()),
        ChangeNotifierProvider.value(value: Scopus()),
      ],
      child: Consumer<UserData>(
          builder: (ctx, userModel, _) => MaterialApp(
                title: 'Academic',
                theme: ThemeData(
                  primarySwatch: Colors.brown,
                  scaffoldBackgroundColor: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                home: userModel.uid != null ? HomePage() : LoginPage(),
                routes: {
                  ProjectsPage.routeName: (ctx) => ProjectsPage(),
                },
              )),
    );
  }
}
