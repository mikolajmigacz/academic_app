import 'dart:io';
import 'package:academic_app/providers/trips.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/adaptive_flat_button.dart';

class NewTrip extends StatefulWidget {
  NewTrip();

  @override
  _NewTripState createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {
  var _isLoading = false;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedDate;
  final _formKey = GlobalKey<FormState>();

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2023),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = DateFormat('dd/MM/yyyy').format(pickedDate).toString();
      });
      print(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TextField(
    //           decoration: const InputDecoration(
    //             labelText: 'Title',
    //             labelStyle: TextStyle(
    //               fontFamily: 'OpenSans',
    //               fontWeight: FontWeight.w400,
    //             ),
    //           ),
    //           controller: _nameController,
    //           onSubmitted: (_) => _submitData(),
    //         ),
    final tripsData = Provider.of<Trips>(context);
    final titleNameField = TextFormField(
      autofocus: false,
      controller: _nameController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Title cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _nameController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Title',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final addressNameField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Address',
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      titleNameField,
                      addressNameField,
                      Container(
                        height: 70,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedDate == null
                                    ? 'Nie wybrano daty'
                                    : 'Data: ${_selectedDate}',
                                style: const TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            AdaptiveFlatButton(
                                'Wybierz date', _presentDatePicker)
                          ],
                        ),
                      ),
                      ElevatedButton(
                        child: Text(
                          'Dodaj Wyjazd',
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
                              tripsData.addTrip(
                                  address: _addressController.text,
                                  date: _selectedDate,
                                  title: _nameController.text);
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
