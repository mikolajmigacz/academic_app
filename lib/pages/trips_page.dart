import 'package:academic_app/shared/constants.dart';
import 'package:academic_app/widgets/app_drawer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trips.dart';
import '../widgets/new_trip.dart';

class TripsPage extends StatefulWidget {
  static String routeName = '/trips';

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final heightOfPage = MediaQuery.of(context).size.height;
    final tripsData = Provider.of<Trips>(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(
          'Wyjazdy/Staże',
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
                        child: NewTrip(),
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
          : tripsData.trips.length == 0
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
                          'swój',
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
                          'wyjazd/staż',
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
                          Text('Liczba wyjazdów: ${tripsData.trips.length}'),
                          Container(
                            height: (heightOfPage * 0.85),
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              itemBuilder: (context, index) {
                                return TripItem(
                                    tripsData.trips[index].city,
                                    tripsData.trips[index].univeristyName,
                                    tripsData.trips[index].dateFrom,
                                    tripsData.trips[index].description,
                                    tripsData.trips[index].dateTo,
                                    tripsData.trips[index].fundName,
                                    tripsData.trips[index].relatedProjectName,
                                    tripsData.removeTrip);
                              },
                              itemCount: tripsData.trips.length,
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
                child: NewTrip(),
                behavior: HitTestBehavior.opaque,
              );
            },
          );
          setState(() {});
        },
      ),
    );
  }

  Widget TripRowItem(IconData icon, String text) {
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

  Widget TripItem(
      String city,
      String univeristyName,
      String dateFrom,
      String description,
      String dateTo,
      String fundName,
      String relatedProjectName,
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
                      Icons.explore,
                      color: Constants.primaryTextColor,
                    ),
                    SizedBox(height: 1),
                    TripRowItem(Icons.location_city, city),
                    SizedBox(height: 1),
                    TripRowItem(Icons.school, univeristyName),
                    SizedBox(height: 1),
                    TripRowItem(
                        Icons.calendar_month, "${dateFrom} - ${dateTo}"),
                    SizedBox(height: 1),
                    TripRowItem(Icons.note_alt, description),
                    SizedBox(height: 1),
                    TripRowItem(Icons.payments, fundName),
                    SizedBox(height: 1),
                    TripRowItem(Icons.description, relatedProjectName),
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
              await deleteFunc(description);
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
