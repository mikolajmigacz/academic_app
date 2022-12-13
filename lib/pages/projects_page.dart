import 'package:academic_app/providers/projects.dart';
import 'package:academic_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/constants.dart';
import '../widgets/new_project.dart';

class ProjectsPage extends StatefulWidget {
  static const routeName = '/projects';

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    final heightOfPage = MediaQuery.of(context).size.height;
    final projectsData = Provider.of<Projects>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Projekty naukowe',
          style: TextStyle(color: Constants.primaryTextColor),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) {
                      return GestureDetector(
                        onTap: () {},
                        child: Center(child: NewPublication()),
                        behavior: HitTestBehavior.opaque,
                      );
                    },
                  );
                  setState(() {});
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : projectsData.projects.length == 0
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/no_items.png",
                          width: 100,
                          height: 150,
                        ),
                        const Text(
                          'Dodaj',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'pierwszy',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'projekt',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Text(
                              'Liczba projektów: ${projectsData.projects.length}'),
                          Container(
                            height: (heightOfPage * 0.85),
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return PublicationItem(
                                    projectsData.projects[index].title,
                                    projectsData.projects[index].foundSource,
                                    projectsData.projects[index].dateFrom,
                                    projectsData.projects[index].dateTo,
                                    projectsData
                                        .projects[index].competitionName,
                                    projectsData.projects[index].roleName,
                                    projectsData.projects[index].coAuthors,
                                    projectsData
                                        .projects[index].isInternational);
                              },
                              itemCount: projectsData.projects.length,
                              // 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget publicationItemRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Constants.primaryTextColor,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Constants.primaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget PublicationItem(
    String title,
    String fundSource,
    String dateFrom,
    String dateTo,
    String competitionName,
    String myRole,
    List<Map<String, String>> coAuthors,
    bool isInternational,
  ) {
    String coAuthorsString = "";
    for (var i = 0; i < coAuthors.length; i++) {
      if (i == coAuthors.length - 1) {
        coAuthorsString += "${coAuthors[i]["name"]}(${coAuthors[i]["role"]})";
      } else {
        coAuthorsString += "${coAuthors[i]["name"]}(${coAuthors[i]["role"]}), ";
      }
    }

    return Card(
      elevation: 5,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
            color: Constants.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Constants.primaryTextColor,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            publicationItemRow(Icons.payments, fundSource),
            const SizedBox(
              height: 1,
            ),
            publicationItemRow(Icons.calendar_month, "${dateFrom} - ${dateTo}"),
            const SizedBox(
              height: 1,
            ),
            publicationItemRow(Icons.info, competitionName),
            const SizedBox(
              height: 1,
            ),
            publicationItemRow(Icons.person, myRole),
            const SizedBox(
              height: 1,
            ),
            publicationItemRow(Icons.public, isInternational ? "Tak" : "Nie"),
            const SizedBox(
              height: 1,
            ),
            publicationItemRow(Icons.group, coAuthorsString),
          ],
        ),
      ),
    );
  }
}
