import 'package:academic_app/pages/about_me_page.dart';
import 'package:academic_app/pages/awards_page.dart';
import 'package:academic_app/pages/publications_page.dart';
import 'package:academic_app/pages/subjects_page.dart';
import 'package:academic_app/pages/thesis_page.dart';
import 'package:academic_app/pages/training_page.dart';
import 'package:academic_app/providers/about_me.dart';
import 'package:academic_app/providers/awards.dart';
import 'package:academic_app/providers/projects.dart';
import 'package:academic_app/providers/thesis.dart';
import 'package:academic_app/providers/training.dart';

import './pages/trips_page.dart';
import 'package:academic_app/providers/speeches.dart';
import 'package:academic_app/providers/subjects.dart';
import 'package:academic_app/providers/trips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './shared/constants.dart';
import './pages/home_page.dart';
import 'pages/projects_page.dart';
import './pages/login_page.dart';
import './pages/speeches_page.dart';
import './providers/user_data.dart';
import './providers/scopus.dart';

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
        ChangeNotifierProvider.value(value: Projects()),
        ChangeNotifierProvider.value(value: UserData()),
        ChangeNotifierProvider.value(value: Scopus()),
        ChangeNotifierProvider.value(value: Speeches()),
        ChangeNotifierProvider.value(value: Trips()),
        ChangeNotifierProvider.value(value: Subjects()),
        ChangeNotifierProvider.value(value: Thesies()),
        ChangeNotifierProvider.value(value: Trainings()),
        ChangeNotifierProvider.value(value: Awards()),
        ChangeNotifierProvider.value(value: AboutMe()),
      ],
      child: Consumer<UserData>(
          builder: (ctx, userData, _) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Academic',
                theme: ThemeData(
                  primarySwatch: Colors.brown,
                  scaffoldBackgroundColor: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                home:
                    // TripsPage(),
                    userData.uid != null ? HomePage() : LoginPage(),
                routes: {
                  ProjectsPage.routeName: (ctx) => ProjectsPage(),
                  SpeechesPage.routeName: (ctx) => SpeechesPage(),
                  TripsPage.routeName: (ctx) => TripsPage(),
                  SubjectsPage.routeName: (ctx) => SubjectsPage(),
                  ThesiesPage.routeName: (ctx) => ThesiesPage(),
                  PublicationsPage.routeName: (ctx) => PublicationsPage(),
                  TrainingPage.routeName: (ctx) => TrainingPage(),
                  AwardsPage.routeName: (ctx) => AwardsPage(),
                  AboutMePage.routeName: (ctx) => AboutMePage(),
                },
              )),
    );
  }
}
