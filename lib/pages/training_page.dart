import 'package:academic_app/providers/training.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:academic_app/widgets/app_drawer.dart';
import 'package:academic_app/widgets/new_training.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingPage extends StatefulWidget {
  static String routeName = '/trainings';

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final heightOfPage = MediaQuery.of(context).size.height;
    final trainingsData = Provider.of<Trainings>(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(
          'Szkolenia',
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
                        child: NewTraining(),
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
          : trainingsData.trainings.length == 0
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
                          'swoje',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'pierwsze',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'szkolenie',
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
                              'Liczba szkoleń: ${trainingsData.trainings.length}'),
                          Container(
                            height: (heightOfPage * 0.85),
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              itemBuilder: (context, index) {
                                return TrainingItem(
                                    trainingsData.trainings[index].address,
                                    trainingsData.trainings[index].title,
                                    trainingsData.trainings[index].certificate,
                                    trainingsData.trainings[index].fundName,
                                    trainingsData.removeTraining);
                              },
                              itemCount: trainingsData.trainings.length,
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
                child: NewTraining(),
                behavior: HitTestBehavior.opaque,
              );
            },
          );
          setState(() {});
        },
      ),
    );
  }

  Widget TrainingItemRow(IconData icon, String text) {
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

  Widget TrainingItem(String address, String title, String certificate,
      String fundName, Future<void> Function(String) deleteFunc) {
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
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryTextColor,
                      ),
                    ),
                    SizedBox(height: 1),
                    TrainingItemRow(Icons.location_city, address),
                    SizedBox(height: 1),
                    TrainingItemRow(Icons.workspace_premium, certificate),
                    SizedBox(height: 1),
                    TrainingItemRow(Icons.payments, fundName),
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
              await deleteFunc(title);
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
