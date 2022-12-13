import 'dart:io';
import 'package:academic_app/providers/about_me.dart';
import 'package:academic_app/providers/projects.dart';
import 'package:academic_app/providers/speeches.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewTitle extends StatefulWidget {
  final String title;
  NewTitle(this.title);

  @override
  _NewTitleState createState() => _NewTitleState();
}

class _NewTitleState extends State<NewTitle> {
  var _isLoading = false;
  final _yearContoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final aboutMeData = Provider.of<AboutMe>(context);
    final yearField = TextFormField(
      autofocus: false,
      controller: _yearContoller,
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: 10,
      onSaved: (value) {
        _yearContoller.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Rok uzyskania ${widget.title}',
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
                          'Dodaj tytuł naukowy',
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
                                if (widget.title == 'magistra') {
                                  aboutMeData.mgr = _yearContoller.text;
                                }
                                if (widget.title == 'inżyniera') {
                                  aboutMeData.inz = _yearContoller.text;
                                }
                                if (widget.title == 'habilitacji') {
                                  aboutMeData.hab = _yearContoller.text;
                                }
                                if (widget.title == 'profesora') {
                                  aboutMeData.prof = _yearContoller.text;
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
