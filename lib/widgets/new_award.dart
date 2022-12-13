import 'dart:io';
import 'package:academic_app/providers/awards.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/adaptive_flat_button.dart';

class NewAward extends StatefulWidget {
  NewAward();

  @override
  _NewAwardState createState() => _NewAwardState();
}

class _NewAwardState extends State<NewAward> {
  var _isLoading = false;
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  String _selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final awardsData = Provider.of<Awards>(context);

    final nameField = TextFormField(
      autofocus: false,
      controller: _nameController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Nazwa cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _nameController.text = value;
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

    final placeField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Miejsce',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      controller: _placeController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _placeController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return ("Place cannot be Empty");
        }
        return null;
      },
    );
    void _presentDatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate =
              DateFormat('dd/MM/yyyy').format(pickedDate).toString();
        });
      });
    }

    final datePicker = Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _selectedDate == null
                  ? 'Nie wybrano daty'
                  : 'Wybrana data: ${_selectedDate}',
              style: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          AdaptiveFlatButton('Wybierz date', _presentDatePicker)
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
                      nameField,
                      placeField,
                      datePicker,
                      ElevatedButton(
                        child: Text(
                          'Dodaj Nagrodę',
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
                              awardsData.addAward(
                                date: _selectedDate,
                                name: _nameController.text,
                                place: _placeController.text,
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
