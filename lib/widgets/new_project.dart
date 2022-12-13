import 'dart:io';
import 'package:academic_app/providers/projects.dart';
import 'package:academic_app/providers/speeches.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:academic_app/widgets/new_co_author.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'adaptive_flat_button.dart';

class NewPublication extends StatefulWidget {
  NewPublication();

  @override
  _NewPublicationState createState() => _NewPublicationState();
}

class _NewPublicationState extends State<NewPublication> {
  var _isLoading = false;
  final _titleController = TextEditingController();
  final _fundSourceController = TextEditingController();
  final _competitionNameController = TextEditingController();
  final _roleNameController = TextEditingController();
  bool isInternational;
  String _selectedFromDate;
  String _selectedToDate;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final projectsData = Provider.of<Projects>(context);

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
        labelText: 'Title',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final fundSourceField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Źródło finansowania',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      controller: _fundSourceController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _fundSourceController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return ("Źródło finansowania nie może być puste");
        }
        return null;
      },
    );

    final competitionNameField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Typ konkursu',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: false,
      controller: _competitionNameController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _competitionNameController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return ("Typ konkursu nie może być pusty");
        }
        return null;
      },
    );

    final myRoleField = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Moja Rola',
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
          return ("Twoja rola w projekcie nie może być pusta");
        }
        return null;
      },
    );

    final isInternationalField = Row(children: [
      Text(
        'Projekt międzynarodowy?',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w500,
          color: Constants.primaryColor,
        ),
      ),
      SizedBox(
        width: 5,
      ),
      DropdownButton(
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
          color: Constants.primaryColor,
        ),
        icon: const Icon(Icons.arrow_downward),
        items: [
          DropdownMenuItem<bool>(
            child: Text('Tak'),
            value: true,
          ),
          DropdownMenuItem(
            child: Text('Nie'),
            value: false,
          ),
        ],
        value: isInternational,
        onChanged: (value) {
          setState(() {
            isInternational = value;
          });
        },
      ),
    ]);
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
                      fundSourceField,
                      competitionNameField,
                      myRoleField,
                      isInternationalField,
                      dateFromPicker,
                      dateToPicker,
                      Text('Współwykonawcy'),
                      projectsData.tempCoWorkers.length == 0
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
                                              "${projectsData.tempCoWorkers[index]["name"]} (${projectsData.tempCoWorkers[index]["role"]})")
                                        ],
                                      );
                                    },
                                    itemCount:
                                        projectsData.tempCoWorkers.length,
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
                          'Dodaj Publikacje',
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
                              projectsData.addProject(
                                title: _titleController.text,
                                roleName: _roleNameController.text,
                                competitionName:
                                    _competitionNameController.text,
                                dateFrom: _selectedFromDate,
                                dateTo: _selectedToDate,
                                foundSource: _fundSourceController.text,
                                isInternational: isInternational,
                                coAuthors: projectsData.tempCoWorkers,
                              );
                              projectsData.tempCoWorkers = [];
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
