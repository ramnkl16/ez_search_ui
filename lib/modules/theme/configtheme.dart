import 'package:flutter/material.dart';

enum ThemeEnum { White, Dark }

String enumName(ThemeEnum anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final ezThemeData = {
  ThemeEnum.White: ThemeData.light().copyWith(
      inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))))),
  ThemeEnum.Dark: ThemeData.dark().copyWith(
      inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))))),
  // ThemeEnum.White: ThemeData(
  //   inputDecorationTheme: const InputDecorationTheme(
  //       border: OutlineInputBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(5)))),
  //   primaryColor: Colors.white,
  //   secondaryHeaderColor: Colors.blueGrey,
  //   //primarySwatch: Colors.grey,
  //   brightness: Brightness.light,
  //   backgroundColor: const Color(0xFFE5E5E5),
  //   dividerColor: Colors.white54,
  // ),
  // ThemeEnum.Dark: ThemeData(
  //   inputDecorationTheme: const InputDecorationTheme(
  //       border: OutlineInputBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(5)))),
  //   primaryColor: Colors.black,
  //   secondaryHeaderColor: Colors.lightBlue,
  //   primarySwatch: Colors.grey,
  //   brightness: Brightness.dark,
  //   backgroundColor: const Color(0xFF212121),
  //   dividerColor: Colors.white12,
  // ),
};
