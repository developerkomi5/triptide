import 'package:flutter/material.dart';
import 'constants.dart';

final ThemeData tripTideTheme = ThemeData(
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kBackgroundColor,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: kTextColor),
    bodyMedium: TextStyle(fontSize: 14, color: kTextColor),
  ),
  fontFamily: 'Roboto',
  useMaterial3: true,
);
