import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello {nameOfUser}!'),
          ),
          ...Provider.of<Categories>(context).categories.map(
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
              onTap: () {},
              // subtitle: Divider()
            ),
          ),
        ],
      ),
    );
  }
}
