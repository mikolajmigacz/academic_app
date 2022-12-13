import 'dart:io';
import 'package:academic_app/providers/projects.dart';
import 'package:academic_app/providers/speeches.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewCoAuthor extends StatefulWidget {
  NewCoAuthor();

  @override
  _NewCoAuthorState createState() => _NewCoAuthorState();
}

class _NewCoAuthorState extends State<NewCoAuthor> {
  var _isLoading = false;
  final _titleController = TextEditingController();
  final _roleNameController = TextEditingController();
  Map<String, String> coAuthor = {};
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final projectsData = Provider.of<Projects>(context);
    final nameField = TextFormField(
      autofocus: false,
      controller: _titleController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Name cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _titleController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Imie i Nazwisko',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final roleField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Rola w projekcie',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      controller: _roleNameController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _roleNameController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return ("Rola w projekcie nie może być pusta");
        }
        return null;
      },
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
                      nameField,
                      roleField,
                      ElevatedButton(
                        child: Text(
                          'Dodaj członka zespołu',
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
                              projectsData.addCoWorker(_titleController.text,
                                  _roleNameController.text);
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
