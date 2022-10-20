import 'package:flutter/material.dart';

import '../shared/constants.dart';

class Categories with ChangeNotifier {
  static const iconSize = 45.0;
  final categories = {
    [
      'Projekty naukowe',
      Icon(Icons.groups_outlined,
          color: Constants.primaryTextColor, size: iconSize)
    ],
    [
      'Moje artykuły',
      Icon(Icons.description_outlined,
          color: Constants.primaryTextColor, size: iconSize)
    ],
    [
      'Wystąpienia',
      Icon(Icons.record_voice_over_outlined,
          color: Constants.primaryTextColor, size: iconSize)
    ],
    [
      'Wyjazdy/Staże',
      Icon(Icons.event_outlined,
          color: Constants.primaryTextColor, size: iconSize)
    ],
    [
      'Statystyki',
      Icon(Icons.trending_up_outlined,
          color: Constants.primaryTextColor, size: iconSize)
    ],
    [
      'Przedmioty',
      Icon(Icons.work_off_outlined,
          color: Constants.primaryTextColor, size: iconSize)
    ],
    [
      'Opieka nad pracami',
      Icon(Icons.supervisor_account_outlined,
          color: Constants.primaryTextColor, size: iconSize)
    ],
  };
}
