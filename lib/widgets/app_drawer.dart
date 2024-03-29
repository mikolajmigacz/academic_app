import 'package:academic_app/pages/about_me_page.dart';
import 'package:academic_app/pages/awards_page.dart';
import 'package:academic_app/pages/home_page.dart';
import 'package:academic_app/pages/login_page.dart';
import 'package:academic_app/pages/publications_page.dart';
import 'package:academic_app/pages/projects_page.dart';
import 'package:academic_app/pages/speeches_page.dart';
import 'package:academic_app/pages/subjects_page.dart';
import 'package:academic_app/pages/thesis_page.dart';
import 'package:academic_app/pages/training_page.dart';
import 'package:academic_app/pages/trips_page.dart';
import 'package:academic_app/providers/about_me.dart';
import 'package:academic_app/providers/awards.dart';
import 'package:academic_app/providers/projects.dart';
import 'package:academic_app/providers/speeches.dart';
import 'package:academic_app/providers/subjects.dart';
import 'package:academic_app/providers/training.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/scopus.dart';
import '../providers/thesis.dart';
import '../providers/user_data.dart';
import '../shared/constants.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    final scopusData = Provider.of<Scopus>(context);
    final speechesData = Provider.of<Speeches>(context);
    final subjectsData = Provider.of<Subjects>(context);
    final thesiesData = Provider.of<Thesies>(context);
    final projectsData = Provider.of<Projects>(context);
    final trainingsData = Provider.of<Trainings>(context);
    final awardsData = Provider.of<Awards>(context);
    final aboutMeData = Provider.of<AboutMe>(context);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/logo_with_letters.png",
              width: 150,
              height: 150,
              color: Colors.brown,
            ),
            Text(
              '${userData.firstName} ${userData.surname}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Constants.primaryColor,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 10),
            Divider(height: 2),
            DrawerItem(
                title: Categories.categories[0][0],
                icon: Categories.categories[0][1],
                func: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()));
                }),
            DrawerItem(
                title: Categories.categories[1][0],
                icon: Categories.categories[1][1],
                func: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AboutMePage.routeName);
                }),
            DrawerItem(
                title: Categories.categories[2][0],
                icon: Categories.categories[2][1],
                func: () {
                  Navigator.of(context)
                      .pushReplacementNamed(ProjectsPage.routeName);
                }),
            DrawerItem(
                title: Categories.categories[3][0],
                icon: Categories.categories[3][1],
                func: () {
                  Navigator.of(context)
                      .pushReplacementNamed(PublicationsPage.routeName);
                }),
            DrawerItem(
                title: Categories.categories[4][0],
                icon: Categories.categories[4][1],
                func: () {
                  Navigator.of(context)
                      .pushReplacementNamed(SpeechesPage.routeName);
                }),
            DrawerItem(
                title: Categories.categories[5][0],
                icon: Categories.categories[5][1],
                func: () {
                  Navigator.of(context)
                      .pushReplacementNamed(TripsPage.routeName);
                }),
            DrawerItem(
                title: Categories.categories[6][0],
                icon: Categories.categories[6][1],
                func: () {
                  Navigator.of(context)
                      .pushReplacementNamed(TrainingPage.routeName);
                }),
            DrawerItem(
                title: Categories.categories[7][0],
                icon: Categories.categories[7][1],
                func: () {
                  Navigator.of(context)
                      .pushReplacementNamed(SubjectsPage.routeName);
                }),
            DrawerItem(
                title: Categories.categories[8][0],
                icon: Categories.categories[8][1],
                func: () {
                  Navigator.of(context)
                      .pushReplacementNamed(ThesiesPage.routeName);
                }),
            DrawerItem(
                title: Categories.categories[9][0],
                icon: Categories.categories[9][1],
                func: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AwardsPage.routeName);
                }),
            DrawerItem(
              title: 'Wyloguj',
              icon: Icons.exit_to_app,
              func: () async {
                await FirebaseAuth.instance.signOut();
                await userData.clearData();
                await scopusData.clearData();
                await speechesData.clearData();
                await subjectsData.clearData();
                await thesiesData.clearData();
                await projectsData.clearData();
                await trainingsData.clearData();
                await awardsData.clearData();
                await aboutMeData.clearData();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function func;
  DrawerItem({this.title, this.icon, this.func});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(5),
      child: ListTile(
        leading: Icon(
          icon,
          color: Constants.primaryColor,
          size: 30,
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Constants.primaryColor,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Constants.primaryTextColor),
            ),
          ),
        ),
        onTap: func,
        // subtitle: Divider()
      ),
    );
  }
}
