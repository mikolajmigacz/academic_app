import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/subjects.dart';
import '../widgets/adaptive_flat_button.dart';

class NewSubject extends StatefulWidget {
  NewSubject();

  @override
  _NewSubjectState createState() => _NewSubjectState();
}

class _NewSubjectState extends State<NewSubject> {
  var _isLoading = false;
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _semesterNumberController = TextEditingController();
  final _hoursController = TextEditingController();
  bool _isLecture = false;
  bool _isLabolatories = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final subjectData = Provider.of<Subjects>(context);
    final titleNameField = TextFormField(
      autofocus: false,
      controller: _nameController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Subject name cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _nameController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Nazwa Przedmiotu',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final codeField = TextFormField(
      autofocus: false,
      controller: _codeController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Code cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _codeController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Kod Przedmiotu',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final semesterNumberField = TextFormField(
      autofocus: false,
      controller: _semesterNumberController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Semester number cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _semesterNumberController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Numer Semestru',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final hoursField = TextFormField(
      autofocus: false,
      controller: _hoursController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Hours cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _hoursController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Ilość godzin',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final isLectureField = Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Container(
            width: 100,
            child: const Text(
              'Wykłady',
              style: TextStyle(
                  color: Constants.primaryColor,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Checkbox(
              activeColor: Constants.primaryColor,
              value: _isLecture,
              onChanged: (bool value) {
                setState(() {
                  _isLecture = value;
                });
              }),
        ],
      ),
    );

    final isLabsField = Row(
      children: [
        Container(
          width: 100,
          child: const Text(
            'Laboratoria',
            style: TextStyle(
                color: Constants.primaryColor,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.normal),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Checkbox(
            activeColor: Constants.primaryColor,
            value: _isLabolatories,
            onChanged: (bool value) {
              setState(() {
                _isLabolatories = value;
              });
            }),
      ],
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
                      codeField,
                      semesterNumberField,
                      isLectureField,
                      isLabsField,
                      hoursField,
                      ElevatedButton(
                        child: Text(
                          'Dodaj Przedmiot',
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
                              subjectData.addSubject(
                                code: _codeController.text,
                                hours: _hoursController.text,
                                isLabolatories: _isLabolatories,
                                isLecture: _isLecture,
                                name: _nameController.text,
                                semesterNumber: _semesterNumberController.text,
                              );
                              _isLecture = false;
                              _isLabolatories = false;
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
