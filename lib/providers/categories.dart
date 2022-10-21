import 'package:flutter/material.dart';

import '../shared/constants.dart';

class Categories with ChangeNotifier {
  static const iconSize = 45.0;
  final categories = {
    ['Projekty naukowe', Icons.groups_outlined],
    ['Moje artykuły', Icons.description_outlined],
    ['Wystąpienia', Icons.record_voice_over_outlined],
    ['Wyjazdy/Staże', Icons.event_outlined],
    ['Statystyki', Icons.trending_up_outlined],
    ['Przedmioty', Icons.work_off_outlined],
    ['Opieka nad pracami', Icons.supervisor_account_outlined],
  };
}
