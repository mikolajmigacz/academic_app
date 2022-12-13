import 'package:academic_app/shared/constants.dart';
import 'package:academic_app/widgets/app_drawer.dart';
import 'package:academic_app/widgets/new_award.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/awards.dart';

class AwardsPage extends StatefulWidget {
  static String routeName = '/awards';

  @override
  State<AwardsPage> createState() => _AwardsPageState();
}

class _AwardsPageState extends State<AwardsPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final heightOfPage = MediaQuery.of(context).size.height;
    final awardsData = Provider.of<Awards>(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(
          'Wyróżnienia i nagrody',
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
                        child: NewAward(),
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
          : awardsData.awards.length == 0
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
                          'nagrodę',
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
                          Text('Liczba nagród: ${awardsData.awards.length}'),
                          Container(
                            height: (heightOfPage * 0.85),
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              itemBuilder: (context, index) {
                                return AwardItem(
                                    awardsData.awards[index].name,
                                    awardsData.awards[index].date,
                                    awardsData.awards[index].place,
                                    awardsData.removeAward);
                              },
                              itemCount: awardsData.awards.length,
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
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
                child: NewAward(),
                behavior: HitTestBehavior.opaque,
              );
            },
          );
          setState(() {});
        },
      ),
    );
  }

  Widget AwardItemRow(IconData icon, String text) {
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

  Widget AwardItem(String name, String date, String place,
      Future<void> Function(String) deleteFunc) {
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
                    Icon(
                      Icons.stars,
                      color: Constants.primaryTextColor,
                    ),
                    SizedBox(height: 1),
                    AwardItemRow(Icons.title, name),
                    SizedBox(height: 1),
                    AwardItemRow(Icons.calendar_month, date),
                    SizedBox(height: 1),
                    AwardItemRow(Icons.pin_drop, place),
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
              await deleteFunc(name);
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
