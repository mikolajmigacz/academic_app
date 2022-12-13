import 'package:academic_app/providers/speeches.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:academic_app/widgets/app_drawer.dart';
import 'package:academic_app/widgets/new_speech.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpeechesPage extends StatefulWidget {
  static String routeName = '/speeches';

  @override
  State<SpeechesPage> createState() => _SpeechesPageState();
}

class _SpeechesPageState extends State<SpeechesPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final heightOfPage = MediaQuery.of(context).size.height;
    final speechesData = Provider.of<Speeches>(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(
          'Konferencje',
          style: TextStyle(color: Constants.primaryTextColor),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return GestureDetector(
                        onTap: () {},
                        child: NewSpeech(),
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
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : speechesData.speeches.length == 0
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
                          'Zaplanuj',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'swoją',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'pierwszą',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'konferencję',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
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
                              'Liczba konferencji: ${speechesData.speeches.length}'),
                          Container(
                            height: (heightOfPage * 0.85),
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              itemBuilder: (context, index) {
                                return SpeechItem(
                                  speechesData.speeches[index].address,
                                  speechesData.speeches[index].conferenceName,
                                  speechesData.speeches[index].speechTitle,
                                  speechesData.speeches[index].dateFrom,
                                  speechesData.speeches[index].dateTo,
                                  speechesData
                                      .speeches[index].relatedProjectName,
                                  speechesData.speeches[index].coAuthors,
                                  speechesData.removeSpeach,
                                );
                              },
                              itemCount: speechesData.speeches.length,
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                // childAspectRatio: (1 / 2),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Constants.primaryColor,
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            builder: (_) {
              return GestureDetector(
                onTap: () {},
                child: NewSpeech(),
                behavior: HitTestBehavior.opaque,
              );
            },
          );
          setState(() {});
        },
      ),
    );
  }

  Widget SpeechRowItem(IconData icon, String text) {
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

  Widget SpeechItem(
      String address,
      String conferenceName,
      String speechTitle,
      String dateFrom,
      String dateTo,
      String projectName,
      List<Map<String, String>> coAuthors,
      Future<void> Function(String, String) deleteFunc) {
    String coAuthorsString = "";
    for (var i = 0; i < coAuthors.length; i++) {
      if (i == coAuthors.length - 1) {
        coAuthorsString += "${coAuthors[i]["name"]}(${coAuthors[i]["role"]})";
      } else {
        coAuthorsString += "${coAuthors[i]["name"]}(${coAuthors[i]["role"]}), ";
      }
    }

    // decoration: BoxDecoration(
    //   gradient: LinearGradient(
    //     colors: [
    //       Constants.primaryColor.withOpacity(0.6),
    //       Constants.primaryColor,
    //     ],
    //     begin: Alignment.topLeft,
    //     end: Alignment.bottomRight,
    //   ),
    //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
    // ),
    // ),
    // Center(
    //   child: IconButton(
    //       onPressed: () async {
    //         setState(() {
    //           _isLoading = true;
    //         });
    //         await deleteFunc(speechTitle);
    //         setState(() {
    //           _isLoading = false;
    //         });
    //       },
    //       icon: Icon(
    //         Icons.delete,
    //         color: Colors.red,
    //       )),
    // )
    // );
    return Card(
      elevation: 5,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Constants.primaryColor.withOpacity(0.6),
                Constants.primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Column(
          children: [
            Text(
              conferenceName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Constants.primaryTextColor,
              ),
            ),
            SizedBox(height: 1),
            SpeechRowItem(Icons.public, address),
            SizedBox(height: 1),
            SpeechRowItem(Icons.calendar_month, "${dateFrom} - ${dateTo}"),
            SizedBox(height: 1),
            SpeechRowItem(Icons.title, speechTitle),
            SizedBox(height: 1),
            SpeechRowItem(Icons.article, projectName),
            SizedBox(height: 1),
            SpeechRowItem(Icons.group, coAuthorsString),
            SizedBox(height: 1),
            Expanded(
              child: Center(
                child: IconButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await deleteFunc(speechTitle, conferenceName);
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
