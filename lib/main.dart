import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './providers/user_data.dart';
import './providers/auth.dart';
import './providers/categories.dart';
import './shared/constants.dart';
import './pages/home_page.dart';
import './pages/projects_page.dart';
import './pages/auth_page.dart';
import './pages/splash_page.dart';

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
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'OpenSans',
      ),
      home: AuthPage(),
      routes: {
        ProjectsPage.routeName: (ctx) => ProjectsPage(),
      },
    );
  }
}
