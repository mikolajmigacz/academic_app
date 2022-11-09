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
  final _formKey = GlobalKey<FormState>();

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
    final subjectData = Provider.of<Subjects>(context);
    final titleNameField = TextFormField(
      autofocus: false,
      controller: _nameController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return ("Subject title cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        _nameController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Subject Name',
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      titleNameField,
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
