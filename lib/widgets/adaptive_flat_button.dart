import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function handler;

  AdaptiveFlatButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
      child: Text(
        text,
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold),
      ),
      onPressed: handler,
    );
  }
}
