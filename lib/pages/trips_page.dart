import 'dart:math';

import 'package:academic_app/providers/speeches.dart';
import 'package:academic_app/providers/trips.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:academic_app/widgets/app_drawer.dart';
import 'package:academic_app/widgets/new_speech.dart';
import 'package:academic_app/widgets/new_trip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripsPage extends StatefulWidget {
  static String routeName = '/trips';

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final tripsData = Provider.of<Trips>(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(
          'Wyjazdy / Staże',
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
                          'pierwszy',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'wyjazd',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  itemBuilder: (context, index) => TripItem(
                      // 'title', 'date', 'address', () {},
                      tripsData.trips[index].title,
                      tripsData.trips[index].date,
                      tripsData.trips[index].address,
                      tripsData.removeTrip),
                  itemCount: tripsData.trips.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: (3 / 2),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 30,
                  ),
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

  Widget TripItem(
      String title, String date, String address, Function deleteFunc) {
    return InkWell(
      splashColor: Constants.primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Column(
              children: [
                Icon(
                  Icons.explore,
                  color: Constants.primaryTextColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.title,
                      color: Constants.primaryTextColor,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: Constants.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Constants.primaryTextColor,
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Constants.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.place,
                      color: Constants.primaryTextColor,
                    ),
                    Text(
                      address,
                      style: TextStyle(
                        color: Constants.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Constants.primaryColor.withOpacity(0.6),
                  Constants.primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
