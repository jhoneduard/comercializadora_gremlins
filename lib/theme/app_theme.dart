import 'package:flutter/material.dart'
    show
        AppBarTheme,
        Color,
        Colors,
        ElevatedButton,
        ElevatedButtonThemeData,
        FloatingActionButtonThemeData,
        StadiumBorder,
        TextButton,
        TextButtonThemeData,
        ThemeData,
        InputDecorationTheme,
        TextStyle,
        OutlineInputBorder,
        BorderSide,
        BorderRadius,
        Radius;

class AppTheme {
  static const Color primary = Colors.indigo;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: primary,
      appBarTheme: const AppBarTheme(color: primary, elevation: 10),
      // TextButton Theme
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primary)),
      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary, elevation: 5),
      // ElevatedButtons
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: const StadiumBorder(),
              elevation: 0)),

              // InputDecortaionTheme 
      inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: primary),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10))),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10))))
                  
                  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: primary,
      appBarTheme: const AppBarTheme(color: primary, elevation: 10),
      scaffoldBackgroundColor: Colors.black);
}
