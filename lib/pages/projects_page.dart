import 'package:academic_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/constants.dart';
import '../providers/scopus.dart';

class ProjectsPage extends StatelessWidget {
  static const routeName = '/projects';

  @override
  Widget build(BuildContext context) {
    final heightOfPage = MediaQuery.of(context).size.height;
    final scopusData = Provider.of<Scopus>(context);
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
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Text('Total documents: ${scopusData.createdDocuments.length}'),
                Container(
                  height: (heightOfPage * 0.9),
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ProjectItem(
                          scopusData.createdDocuments[index]['title'],
                          scopusData.createdDocuments[index]['publicationName'],
                          scopusData.createdDocuments[index]['creator'],
                          scopusData.createdDocuments[index]['dateOfCreation'],
                          scopusData.createdDocuments[index]['citedByCount'],
                          scopusData.createdDocuments[index]['link']);
                      // 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                      // 'Product Name',
                      // 'Author',
                      // 'March 2022',
                      // '2',
                      // 'https://stackoverflow.com/questions/43583411/how-to-create-a-hyperlink-in-flutter-widget',
                      // );
                    },
                    itemCount: scopusData.createdDocuments.length,
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

  Widget projectItemRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Constants.primaryTextColor,
        ),
        SizedBox(
          width: 3,
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

  Widget ProjectItem(String title, String publicationName, String author,
      String date, String citedCount, String url) {
    final linkRow = Row(
      children: [
        Icon(
          Icons.language,
          color: Constants.primaryTextColor,
        ),
        SizedBox(
          width: 3,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Constants.primaryTextColor,
              borderRadius: BorderRadius.all(Radius.circular(
                5.0,
              ))),
          child: GestureDetector(
            child: Text(
              'See in Scopus',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Constants.primaryColor),
            ),
            onTap: (() => launchUrl(Uri.parse(url))),
          ),
        ),
      ],
    );
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
            projectItemRow(Icons.article, title),
            const SizedBox(
              height: 1,
            ),
            projectItemRow(Icons.drive_file_rename_outline, publicationName),
            const SizedBox(
              height: 1,
            ),
            projectItemRow(Icons.person, author),
            const SizedBox(
              height: 1,
            ),
            projectItemRow(Icons.date_range, date),
            const SizedBox(
              height: 1,
            ),
            projectItemRow(Icons.pin, citedCount),
            const SizedBox(
              height: 1,
            ),
            linkRow
          ],
        ),
      ),
    );
  }
}
