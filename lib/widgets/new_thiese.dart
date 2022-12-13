import 'package:academic_app/providers/thesis.dart';
import 'package:academic_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/adaptive_flat_button.dart';

class NewThiese extends StatefulWidget {
  NewThiese();

  @override
  _NewThieseState createState() => _NewThieseState();
}

class _NewThieseState extends State<NewThiese> {
  var _isLoading = false;
  final _nameAndSurnameController = TextEditingController();
  final _recenzentNameController = TextEditingController();
  final _indexNumberController = TextEditingController();
  final _promotorNameController = TextEditingController();
  final _titleInPolishController = TextEditingController();
  final _titleInEnglishController = TextEditingController();
  final _yearOfDefenseController = TextEditingController();
  bool _isInz = false;
  bool _isMgr = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final thesiesData = Provider.of<Thesies>(context);

    final defenseYearField = TextFormField(
      autofocus: false,
      controller: _yearOfDefenseController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Rok obrony cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _yearOfDefenseController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Rok obrony',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final titleInEnglishField = TextFormField(
      autofocus: false,
      controller: _titleInEnglishController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Tytuł cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _titleInEnglishController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Tytuł (Angielski)',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final titleInPolishField = TextFormField(
      autofocus: false,
      controller: _titleInPolishController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Tytuł cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _titleInPolishController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Tytuł (Polski)',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final nameAndSurnameField = TextFormField(
      autofocus: false,
      controller: _nameAndSurnameController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Imie i nazwisko cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _nameAndSurnameController.text = value;
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

    final recenzentField = TextFormField(
      autofocus: false,
      controller: _recenzentNameController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Recenzent cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _recenzentNameController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Recenzent',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final indeksNumberField = TextFormField(
      autofocus: false,
      controller: _indexNumberController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Indeks number cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _indexNumberController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Numer Indeksu',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final promotorField = TextFormField(
      autofocus: false,
      controller: _promotorNameController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Promotor cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _promotorNameController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Promotor',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final isMgrField = Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Container(
            width: 100,
            child: const Text(
              'Magisterska',
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
              value: _isMgr,
              onChanged: (bool value) {
                setState(() {
                  _isMgr = value;
                });
              }),
        ],
      ),
    );

    final isInzField = Row(
      children: [
        Container(
          width: 100,
          child: const Text(
            'Inżynierska',
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
            value: _isInz,
            onChanged: (bool value) {
              setState(() {
                _isInz = value;
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
                      nameAndSurnameField,
                      indeksNumberField,
                      recenzentField,
                      promotorField,
                      defenseYearField,
                      titleInPolishField,
                      titleInEnglishField,
                      isInzField,
                      isMgrField,
                      ElevatedButton(
                        child: Text(
                          'Dodaj Prace',
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
                              thesiesData.addThesis(
                                indexNumber: _indexNumberController.text,
                                isInz: _isInz,
                                isMgr: _isMgr,
                                nameAndSurname: _nameAndSurnameController.text,
                                promotorName: _promotorNameController.text,
                                recenzentName: _recenzentNameController.text,
                                titleInEnglish: _titleInEnglishController.text,
                                titleInPolish: _titleInPolishController.text,
                                yearOfDefense: _yearOfDefenseController.text,
                              );
                              _isInz = false;
                              _isMgr = false;
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
