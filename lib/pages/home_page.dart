import 'package:academic_app/providers/scopus.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/user_data.dart';
import '../widgets/category_item.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        margin: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(
                Icons.account_circle,
                size: 80,
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
              SizedBox(
                height: 20,
              ),
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
                child: ListView.builder(
                  itemBuilder: (context, index) => ArticleItem(
                    author:
                        // 'Jeden i ten sam',
                        scopusData.createdDocuments[index]['creator'],
                    citations:
                        // '69',
                        scopusData.createdDocuments[index]['citedByCount'],
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
  final int number;
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
