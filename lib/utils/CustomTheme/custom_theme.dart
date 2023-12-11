import 'package:flutter/material.dart';

Color mainColor = const Color(0xFFDC202E);

class DataCustom {
  OutlineInputBorder border = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(width: 1, color: Colors.black.withOpacity(0.8)),
  );
  OutlineInputBorder border2 = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(width: 1, color: mainColor));
  AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: mainColor,
    toolbarHeight: 70,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
  );
  TextTheme textTheme = const TextTheme(
      bodyMedium: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
      titleMedium: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
      titleSmall: TextStyle(fontWeight: FontWeight.w400, color: Colors.black));
  TextSelectionThemeData textSelectionThemeData = const TextSelectionThemeData(
      selectionColor: Colors.grey,
      cursorColor: Color(0xff171d49),
      selectionHandleColor: Color(0xff005e91));
  FloatingActionButtonThemeData floatingActionButtonThemeData =
      FloatingActionButtonThemeData(
          backgroundColor: mainColor,
          focusColor: mainColor,
          splashColor: mainColor);
}

DataCustom dataCustom = DataCustom();

class CustomThemeData {
  ThemeData themeData = ThemeData(
      fontFamily: "Quicksand",
      appBarTheme: dataCustom.appBarTheme,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
      ),
      textTheme: dataCustom.textTheme,
      textSelectionTheme: dataCustom.textSelectionThemeData,
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: Colors.green, primary: mainColor),
      brightness: Brightness.light,
      highlightColor: Colors.white,
      floatingActionButtonTheme: dataCustom.floatingActionButtonThemeData,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 4, 194, 207),
          unselectedItemColor: Color.fromRGBO(0, 0, 0, 0.5)));
}
