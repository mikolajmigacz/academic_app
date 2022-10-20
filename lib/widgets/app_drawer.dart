import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello {nameOfUser}!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),

          // ListTile(
          //   leading: Icon(Icons.shop),
          //   title: Text('Shop'),
          //   // onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          // ),
        ],
      ),
    );
  }
}
