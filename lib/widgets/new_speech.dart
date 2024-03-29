import 'dart:io';
import 'package:academic_app/providers/speeches.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/adaptive_flat_button.dart';
import 'new_speech/new_co_author.dart';

class NewSpeech extends StatefulWidget {
  NewSpeech();

  @override
  _NewSpeechState createState() => _NewSpeechState();
}

class _NewSpeechState extends State<NewSpeech> {
  var _isLoading = false;
  final _speechTitleController = TextEditingController();
  final _addressController = TextEditingController();
  final _conferenceNameController = TextEditingController();
  final _projectNameController = TextEditingController();
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
    final speechesData = Provider.of<Speeches>(context);
    final titleNameField = TextFormField(
      autofocus: false,
      controller: _conferenceNameController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Title cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _conferenceNameController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Nazwa Konferencji',
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

    final speechTitleField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Tytuł Wystąpienia',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      controller: _speechTitleController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _speechTitleController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return ("Tytuł wystąpienia nie może być pusty");
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
      controller: _projectNameController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _projectNameController.text = value;
      },
      validator: (value) {
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
                      titleNameField,
                      addressNameField,
                      dateFromPicker,
                      dateToPicker,
                      speechTitleField,
                      relatedProjectNameField,
                      Text('Współwykonawcy'),
                      speechesData.tempCoWorkers.length == 0
                          ? Text('Brak')
                          : SingleChildScrollView(
                              child: Flexible(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: 100,
                                  ),
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Icon(Icons.person),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                              "${speechesData.tempCoWorkers[index]["name"]} (${speechesData.tempCoWorkers[index]["role"]})")
                                        ],
                                      );
                                    },
                                    itemCount:
                                        speechesData.tempCoWorkers.length,
                                  ),
                                ),
                              ),
                            ),
                      IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (_) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Center(child: NewCoAuthor()),
                                  behavior: HitTestBehavior.opaque,
                                );
                              },
                            );
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.add,
                            color: Constants.primaryColor,
                          )),
                      ElevatedButton(
                        child: Text(
                          'Dodaj Konferencje',
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
                              speechesData.addSpeech(
                                speechTitle: _speechTitleController.text,
                                conferenceName: _conferenceNameController.text,
                                address: _addressController.text,
                                dateFrom: _selectedFromDate,
                                dateTo: _selectedToDate,
                                projectName: _projectNameController?.text,
                                coAuthors: speechesData.tempCoWorkers,
                              );
                              speechesData.tempCoWorkers = [];
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
