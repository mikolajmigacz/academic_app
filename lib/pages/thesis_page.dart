import 'package:academic_app/providers/thesis.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:academic_app/widgets/app_drawer.dart';
import 'package:academic_app/widgets/new_thiese.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThesiesPage extends StatefulWidget {
  static String routeName = '/thesies';

  @override
  State<ThesiesPage> createState() => _ThesiesPageState();
}

class _ThesiesPageState extends State<ThesiesPage> {
  bool _isLoading = false;

  bool _showInz = true;
  bool _showMgr = true;

  @override
  Widget build(BuildContext context) {
    final thesiesData = Provider.of<Thesies>(context);
    final heightOfPage = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(
          'Opieka nad pracami',
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
                        child: NewThiese(),
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
          : thesiesData.thesies.length == 0
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
                                      value: _showInz,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _showInz = value;
                                        });
                                      }),
                                  Text(
                                    "Inżynierskie",
                                    style: TextStyle(
                                        color: Constants.primaryColor,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              Column(
                                children: [
                                  Checkbox(
                                      activeColor: Constants.primaryColor,
                                      value: _showMgr,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _showMgr = value;
                                        });
                                      }),
                                  Text(
                                    "Magisterskie",
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
                              'Suma Prowadzonych prac: ${thesiesData.thesies.length}',
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
                            child: mainList(thesiesData),
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
                child: NewThiese(),
                behavior: HitTestBehavior.opaque,
              );
            },
          );
          setState(() {});
        },
      ),
    );
  }

  Widget mainList(Thesies thesiesData) {
    List<Thesis> thesies = (_showInz && _showMgr)
        ? thesiesData.thesies
        : thesiesData.thesies
            .where((element) =>
                (element.isInz == _showInz && element.isMgr == _showMgr))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        return ThesiesItem(
            thesies[index].nameAndSurname,
            thesies[index].indexNumber,
            thesies[index].recenzentName,
            thesies[index].promotorName,
            thesies[index].titleInPolish,
            thesies[index].titleInEnglish,
            thesies[index].yearOfDefense,
            thesies[index].isInz,
            thesies[index].isMgr,
            thesiesData.removeThiese);
      },
      itemCount: thesies.length,
    );
  }

  Widget thesiesItemRow(IconData icon, String text) {
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

  Widget ThesiesItem(
      String nameAndSurname,
      String indexNumber,
      String recenzentName,
      String promotorName,
      String titleInPolish,
      String titleInEnglish,
      String yearOfDefense,
      bool isInz,
      bool isMgr,
      Future<void> Function(String, String) deleteFunc) {
    final promotorRow = Row(
      children: [
        Text(
          "P",
          style: TextStyle(
              color: Constants.primaryTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            promotorName,
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

    final recenzentRow = Row(
      children: [
        Text(
          "R",
          style: TextStyle(
              color: Constants.primaryTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            recenzentName,
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

    return Column(
      children: [
        Card(
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
                  titleInPolish,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Constants.primaryTextColor,
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Text(
                  isInz ? "Inżynierska" : "Magisterska",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: Constants.primaryTextColor,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                thesiesItemRow(Icons.person, nameAndSurname),
                const SizedBox(
                  height: 1,
                ),
                thesiesItemRow(Icons.numbers, indexNumber),
                const SizedBox(
                  height: 1,
                ),
                Container(
                    margin: EdgeInsets.only(right: 2), child: promotorRow),
                const SizedBox(
                  height: 1,
                ),
                Container(
                    margin: EdgeInsets.only(right: 2), child: recenzentRow),
                const SizedBox(
                  height: 1,
                ),
                thesiesItemRow(Icons.public, titleInEnglish),
                const SizedBox(
                  height: 1,
                ),
                thesiesItemRow(Icons.calendar_month, yearOfDefense),
              ],
            ),
          ),
        ),
        IconButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await deleteFunc(indexNumber, titleInPolish);
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
