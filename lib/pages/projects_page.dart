import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectsPage extends StatelessWidget {
  static const routeName = '/projects';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projekty naukowe'),
        centerTitle: true,
      ),
      body: Center(child: Text('ProjectsPage')),
    );
  }
}
