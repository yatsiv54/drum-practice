import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF1F4367),
  primaryColor: const Color(0xFF1F4367),
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 49,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),

    bodySmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(113, 158, 197, 1),
    ),
  ),
);
