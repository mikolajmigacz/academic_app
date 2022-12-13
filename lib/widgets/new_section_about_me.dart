import 'dart:io';
import 'package:academic_app/providers/about_me.dart';
import 'package:academic_app/providers/projects.dart';
import 'package:academic_app/providers/speeches.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewSection extends StatefulWidget {
  final String title;
  NewSection(this.title);

  @override
  _NewSectionState createState() => _NewSectionState();
}

class _NewSectionState extends State<NewSection> {
  var _isLoading = false;
  final _longTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // edukacji
  // działalności naukowej i zainteresowań
  // doświadczenia zawodowego

  @override
  Widget build(BuildContext context) {
    final aboutMeData = Provider.of<AboutMe>(context);
    final yearField = TextFormField(
      autofocus: false,
      controller: _longTextController,
      keyboardType: TextInputType.multiline,
      minLines: 4,
      maxLines: 20,
      onSaved: (value) {
        _longTextController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "Opis ${widget.title}",
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    return SingleChildScrollView(
      child: _isLoading == true
          ? CircularProgressIndicator()
          : Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      yearField,
                      ElevatedButton(
                        child: Text(
                          'Dodaj opis ${widget.title}',
                          style: TextStyle(
                              color: Constants.primaryTextColor,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.normal),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            try {
                              setState(() {
                                _isLoading = true;
                              });
                              findAndSaveVariable() async {
                                if (widget.title == 'edukacji') {
                                  aboutMeData.education =
                                      _longTextController.text;
                                } else if (widget.title ==
                                    'działalności naukowej i zainteresowań') {
                                  aboutMeData.description =
                                      _longTextController.text;
                                } else if (widget.title ==
                                    'doświadczenia zawodowego') {
                                  aboutMeData.experience =
                                      _longTextController.text;
                                }
                              }

                              await findAndSaveVariable();
                              await aboutMeData.saveData();
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.of(context).pop();
                            } catch (error) {
                              print(error.toString());
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
