import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';

ThemeData LightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        background: Color.fromRGBO(223, 245, 255, 1),
        primary: Color.fromRGBO(55, 140, 231, 1),
        secondary: Color.fromRGBO(103, 198, 227, 1)),
    // scaffoldBackgroundColor: Color.fromRGBO(83, 86, 255, 1),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            textStyle: WidgetStateProperty.all<TextStyle>(
                GoogleFonts.agdasima(color: Colors.white)))),
    appBarTheme: AppBarTheme(
        centerTitle: true,
        color: Color.fromRGBO(83, 86, 255, 1),
        titleTextStyle: GoogleFonts.agdasima(fontSize: 40)),
    drawerTheme: DrawerThemeData(
      shape: Border.all(color: Colors.black),
      backgroundColor: const Color.fromRGBO(103, 198, 227, 1),
    ),
    textTheme: TextTheme(bodySmall: GoogleFonts.agdasima(color: Colors.white)),
    scaffoldBackgroundColor: Color.fromRGBO(103, 198, 227, 1));

ThemeData DarkTheme = ThemeData(
  brightness: Brightness.dark,
  // colorScheme: ColorScheme.dark(
  //   background: ,
  //   primary: ,
  //   secondary: ,

  // ),
);
