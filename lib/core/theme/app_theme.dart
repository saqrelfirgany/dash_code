import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(elevation: 2),
  );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    primaryColor: Colors.blueGrey,
    appBarTheme: const AppBarTheme(elevation: 2),
  );
}