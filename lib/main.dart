import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './shared/constants.dart';
import './pages/home_page.dart';
import './pages/projects_page.dart';
import './pages/login_page.dart';
import './providers/user_model.dart';

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
        ChangeNotifierProvider.value(value: UserModel()),
      ],
      child: Consumer<UserModel>(
          builder: (ctx, userModel, _) => MaterialApp(
                title: 'Academic',
                theme: ThemeData(
                  primarySwatch: Colors.brown,
                  scaffoldBackgroundColor: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                home: userModel.uid != null ? HomePage() : LoginPage(),
                routes: {
                  // HomePage.routeName: (ctx) => HomePage(),
                  ProjectsPage.routeName: (ctx) => ProjectsPage(),
                },
              )),
    );
  }
}
