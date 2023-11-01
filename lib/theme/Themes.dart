import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

ThemeData theme = ThemeData(
  backgroundColor: CupertinoColors.white,
  fontFamily: 'Asap',

  appBarTheme: const AppBarTheme(
    backgroundColor: CupertinoColors.white,
    foregroundColor: background,
  ),

  scaffoldBackgroundColor: CupertinoColors.white,
);