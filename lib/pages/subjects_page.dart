import 'package:academic_app/providers/subjects.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:academic_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/new_subject.dart';

class SubjectsPage extends StatefulWidget {
  static String routeName = '/subjects';

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  bool _isLoading = false;

  bool _showLectures = true;
  bool _showLabs = true;

  @override
  Widget build(BuildContext context) {
    final subjectsData = Provider.of<Subjects>(context);
    final heightOfPage = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(
          'Dydaktyka',
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
                        child: NewSubject(),
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
          : subjectsData.subjects.length == 0
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
                          'prowadzony',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'przedmiot',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Checkbox(
                                      activeColor: Constants.primaryColor,
                                      value: _showLabs,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _showLabs = value;
                                        });
                                      }),
                                  Text(
                                    "Laboratoria",
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Column(
                                children: [
                                  Checkbox(
                                      activeColor: Constants.primaryColor,
                                      value: _showLectures,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _showLectures = value;
                                        });
                                      }),
                                  Text(
                                    "Wykłady",
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Constants.primaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(
                                  5.0,
                                ))),
                            child: Text(
                              'Suma przedmiotów: ${subjectsData.subjects.length}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Constants.primaryTextColor),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: (heightOfPage * 0.80),
                            width: MediaQuery.of(context).size.width,
                            child: mainGrid(subjectsData),
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
                child: NewSubject(),
                behavior: HitTestBehavior.opaque,
              );
            },
          );
          setState(() {});
        },
      ),
    );
  }

  Widget mainGrid(Subjects subjectsData) {
    List<Subject> subjects = subjectsData.subjects
        .where((element) => (element.isLecture == _showLectures &&
            element.isLabolatories == _showLabs))
        .toList();
    return GridView.builder(
      itemBuilder: (context, index) {
        return SubjectItem(
            subjects[index].code,
            subjects[index].name,
            subjects[index].semesterNumber,
            subjects[index].isLecture,
            subjects[index].isLabolatories,
            subjects[index].hours,
            subjectsData.removeSubject);
      },
      itemCount: subjects.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
    );
  }

  Widget SubjectItemRow(IconData icon, String text) {
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

  Widget SubjectItem(
      String code,
      String name,
      String semesterNumber,
      bool isLecture,
      bool isLabolatories,
      String hours,
      Future<void> Function(String) deleteFunc) {
    final isLectureRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Wykłady",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Constants.primaryTextColor,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          isLecture ? Icons.check_circle : Icons.cancel,
          color: Constants.primaryTextColor,
        ),
      ],
    );

    final isLabRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Laboratoria",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Constants.primaryTextColor,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          isLabolatories ? Icons.check_circle : Icons.cancel,
          color: Constants.primaryTextColor,
        ),
      ],
    );
    return Column(
      children: [
        Flexible(
          child: Card(
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryTextColor,
                      ),
                    ),
                    SizedBox(height: 1),
                    SubjectItemRow(Icons.vpn_key, code),
                    SizedBox(height: 1),
                    SubjectItemRow(Icons.pin, semesterNumber),
                    SizedBox(height: 1),
                    SubjectItemRow(Icons.hourglass_empty, hours),
                    SizedBox(height: 1),
                    isLectureRow,
                    SizedBox(height: 1),
                    isLabRow,
                  ],
                ),
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await deleteFunc(code);
              setState(() {
                _isLoading = false;
              });
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            )),
      ],
    );
  }
}
