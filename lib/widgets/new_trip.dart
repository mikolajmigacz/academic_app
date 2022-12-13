import 'package:academic_app/providers/trips.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'dart:io';

import 'package:intl/intl.dart';

import '../widgets/adaptive_flat_button.dart';

class NewTrip extends StatefulWidget {
  NewTrip();

  @override
  _NewTripState createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {
  var _isLoading = false;
  final _cityController = TextEditingController();
  final _univeristyNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _fundNameController = TextEditingController();
  final _relatedProjectNameController = TextEditingController();
  String _selectedToDate;
  String _selectedFromDate;
  final _formKey = GlobalKey<FormState>();

  void _presentDateFromPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedFromDate =
            DateFormat('dd/MM/yyyy').format(pickedDate).toString();
      });
    });
  }

  void _presentDateToPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedToDate =
            DateFormat('dd/MM/yyyy').format(pickedDate).toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripsData = Provider.of<Trips>(context);
    final cityField = TextFormField(
      autofocus: false,
      controller: _cityController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("City cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _cityController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Miasto',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final univeristyNameField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Nazwa Uczelni',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      controller: _univeristyNameController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _univeristyNameController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return ("Nazwa uczelni nie może być pusta");
        }
        return null;
      },
    );

    final descriptionField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Opis',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      controller: _descriptionController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _descriptionController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return ("Opis nie może być pusty");
        }
        return null;
      },
    );

    final relatedProjectNameField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Powiązany projekt',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      controller: _relatedProjectNameController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _relatedProjectNameController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return ("Powiązany projekt nie może być pusty");
        }
        return null;
      },
    );

    final fundNameField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Finansowanie',
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
          return ("Finansowanie nie może być puste");
        }
        return null;
      },
    );

    final dateFromPicker = Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _selectedFromDate == null
                  ? 'Nie wybrano daty rozpoczęcia'
                  : 'Data rozpoczęcia: ${_selectedFromDate}',
              style: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          AdaptiveFlatButton('Wybierz date', _presentDateFromPicker)
        ],
      ),
    );

    final dateToPicker = Container(
      margin: EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _selectedFromDate == null
                  ? 'Nie wybrano daty zakończenia'
                  : 'Data rozpoczęcia: ${_selectedToDate}',
              style: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          AdaptiveFlatButton('Wybierz date', _presentDateToPicker)
        ],
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
                      cityField,
                      univeristyNameField,
                      dateFromPicker,
                      dateToPicker,
                      descriptionField,
                      fundNameField,
                      relatedProjectNameField,
                      ElevatedButton(
                        child: Text(
                          'Dodaj Wyjazd/Staż',
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
                                city: _cityController.text,
                                dateFrom: _selectedFromDate,
                                dateTo: _selectedToDate,
                                description: _descriptionController.text,
                                fundName: _fundNameController.text,
                                relatedProjectName:
                                    _relatedProjectNameController.text,
                                univeristyName: _univeristyNameController.text,
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
