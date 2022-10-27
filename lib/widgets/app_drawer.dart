import 'package:academic_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/user_data.dart';
import '../shared/constants.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              '../assets/images/logo_with_letters.png',
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
            ...Categories.categories.map(
              (e) => Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.all(5),
                child: ListTile(
                  leading: Icon(
                    e[1] as IconData,
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
                        e[0] as String,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Constants.primaryTextColor),
                      ),
                    ),
                  ),
                  onTap: () {},
                  // subtitle: Divider()
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(5),
              child: ListTile(
                leading: Icon(
                  Icons.exit_to_app,
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
                      'Wyloguj',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Constants.primaryTextColor),
                    ),
                  ),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  userData.clearData();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
