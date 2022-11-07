import 'dart:math';

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
    final speechesData = Provider.of<Speeches>(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(
          'Wystąpienia',
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
                          'swoje',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'piersze',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'wystąpienie',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(15),
                  itemBuilder: (context, index) => SpeechItem(
                      speechesData.speeches[index].title,
                      speechesData.speeches[index].date,
                      speechesData.speeches[index].address,
                      speechesData.removeSpeach),
                  itemCount: speechesData.speeches.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: (3 / 2),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
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

  Widget SpeechItem(
      String title, String date, String address, Function deleteFunc) {
    return InkWell(
      onTap: () {},
      splashColor: Constants.primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                SizedBox(height: 8),
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
                SizedBox(height: 8),
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
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              // borderRadius: BorderRadius.only(
              //   bottomLeft: Radius.circular(15),
              //   bottomRight: Radius.circular(15),
              // ),
              // border: Border.all(color: Constants.primaryColor, width: 2)),
              // Border(
              //     bottom:
              //         BorderSide(color: Constants.primaryColor, width: 2))),
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
          )
        ],
      ),
    );
  }
}
