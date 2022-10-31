import 'package:academic_app/providers/scopus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/user_data.dart';
import '../widgets/category_item.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    final scopusData = Provider.of<Scopus>(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Image.asset(
          '../assets/images/logo.png',
          width: 75,
          height: 75,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('userData'),
              Text('firstName: ${userData.firstName}'),
              Text('surname: ${userData.surname}'),
              Text('city: ${userData.city}'),
              Text('email: ${userData.email}'),
              Text('scopusData'),
              Text('authorId: ${scopusData.authorId}'),
              Text('orcid: ${scopusData.orcid}'),
              Text('universityName: ${scopusData.universityName}'),
              Text('scopusProfileLink: ${scopusData.scopusProfileLink}'),
              Text('createdDocuments: ${scopusData.createdDocuments[4]}'),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
