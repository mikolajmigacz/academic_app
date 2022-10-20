import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  static const routeName = '/projects';
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projekty naukowe'),
        centerTitle: true,
      ),
      body: Center(child: Text('ProjectPage')),
    );
  }
}
