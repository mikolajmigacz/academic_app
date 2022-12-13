import 'package:academic_app/pages/projects_page.dart';
import 'package:academic_app/pages/publications_page.dart';
import 'package:academic_app/providers/thesis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/constants.dart';
import '../providers/subjects.dart';
import '../providers/scopus.dart';
import '../providers/user_data.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserData>(context);
    var scopusData = Provider.of<Scopus>(context);
    var subjectData = Provider.of<Subjects>(context);
    var thesisData = Provider.of<Thesies>(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Image.asset(
            "assets/images/logo.png",
            width: 75,
            height: 75,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/profile.png",
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${userData.firstName} ${userData.surname}',
                // 'name surname',

                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${scopusData.universityName}'),
              // 'university Name'),
              SizedBox(
                height: 20,
              ),
              Divider(),
              Text(
                'Statystyki',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //start Documents created Statistics widget
                  CircleColorWidget(
                    color: Colors.purple,
                    number: (scopusData.createdDocuments.length == 0 ||
                            scopusData.createdDocuments.length == null)
                        ? 0
                        : scopusData.createdDocuments.length,
                    // number: 25,
                    text: 'Documents',
                    icon: Icons.description_outlined,
                  ),
                  CircleColorWidget(
                    color: Colors.red,
                    number: scopusData.citationSummary,
                    // number: 98,
                    text: 'Citations',
                    icon: Icons.sync,
                  ),
                  CircleColorWidget(
                    color: Colors.yellow,
                    number: scopusData.hirischIndex,
                    // number: 6,
                    text: 'Hirish index',
                    icon: Icons.star_rate,
                  ),
                ],
              ),

              ((subjectData.subjects.length == 0 ||
                          subjectData.subjects.length == null) &&
                      (subjectData.subjects.length == 0 ||
                          scopusData.createdDocuments.length == null))
                  ? SizedBox.shrink()
                  : Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //start Documents created Statistics widget
                          CircleColorWidget(
                            color: Colors.blue,
                            number: (subjectData.subjects.length == 0 ||
                                    subjectData.subjects.length == null)
                                ? 0
                                : subjectData.subjects.length,
                            // number: 25,
                            text: 'Przedmioty',
                            icon: Icons.work_outline,
                          ),
                          CircleColorWidget(
                            color: Colors.teal,
                            number: (subjectData.subjects.length == 0 ||
                                    scopusData.createdDocuments.length == null)
                                ? 0
                                : thesisData.thesies.length,
                            // number: 98,
                            text: 'Opieka nad pracami',
                            icon: Icons.supervisor_account_outlined,
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              Text(
                'Ostatnie Artykuły',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 180,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => ArticleItem(
                          author:
                              // 'Jeden i ten sam',
                              scopusData.createdDocuments[index]['creator'],
                          citations:
                              // '69',
                              scopusData.createdDocuments[index]
                                  ['citedByCount'],
                          title:
                              // 'Taki sam jak zawsze jest',
                              scopusData.createdDocuments[index]['title'],
                        ),
                        itemCount:
                            // 5,
                            scopusData.createdDocuments?.length == 0 ||
                                    scopusData.createdDocuments?.length == null
                                ? 0
                                : scopusData.createdDocuments?.length < 5
                                    ? scopusData.createdDocuments?.length
                                    : 5,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.forward),
                        onPressed: () => {
                              Navigator.of(context).pushReplacementNamed(
                                  PublicationsPage.routeName)
                            })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}

class ArticleItem extends StatelessWidget {
  final String title;
  final String author;
  final String citations;
  ArticleItem({this.author, this.citations, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: Constants.primaryColor,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Center(
                child: Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: 120,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person,
                        color: Constants.primaryTextColor,
                      ),
                      Container(
                        width: 80,
                        child: Text(
                          author,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Constants.primaryTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.sync,
                        color: Constants.primaryTextColor,
                      ),
                      Text(
                        citations,
                        style: TextStyle(
                          fontSize: 16,
                          color: Constants.primaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleColorWidget extends StatelessWidget {
  final Color color;
  int number;
  final String text;
  final IconData icon;

  CircleColorWidget({this.color, this.number, this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: color.withOpacity(0.1)),
          width: 50,
          height: 50,
          child: Icon(
            icon,
            color: color,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '${number}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(text),
      ],
    );
  }
}
