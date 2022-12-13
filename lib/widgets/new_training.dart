import 'dart:io';
import 'package:academic_app/providers/training.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/adaptive_flat_button.dart';

class NewTraining extends StatefulWidget {
  NewTraining();

  @override
  _NewTrainingState createState() => _NewTrainingState();
}

class _NewTrainingState extends State<NewTraining> {
  var _isLoading = false;
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _certificateController = TextEditingController();
  final _fundNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final trainingsData = Provider.of<Trainings>(context);
    final titleNameField = TextFormField(
      autofocus: false,
      controller: _titleController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Title cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _titleController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Nazwa',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final addressNameField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Miejsce',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      controller: _addressController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _addressController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return ("Address cannot be Empty");
        }
        return null;
      },
    );
    final certificateField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Certyfikat',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      controller: _certificateController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _certificateController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return ("Certyfikat cannot be Empty");
        }
        return null;
      },
    );
    final fundNameField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Źródło finansowania',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      controller: _fundNameController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _fundNameController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return ("Źródło finansowania cannot be Empty");
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
                      titleNameField,
                      addressNameField,
                      certificateField,
                      fundNameField,
                      ElevatedButton(
                        child: Text(
                          'Dodaj Szkolenie',
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
                              trainingsData.addTraining(
                                address: _addressController.text,
                                certificate: _certificateController.text,
                                fundName: _fundNameController.text,
                                title: _titleController.text,
                              );

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
