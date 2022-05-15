import 'package:flutter/material.dart';

enum ThemeEnum { White, Dark }

String enumName(ThemeEnum anyEnum) {
  return anyEnum.toString().split('.')[1];
}

ThemeEnum ezCurThemeName = ThemeEnum.White;

final ezThemeData = {
  ThemeEnum.White: ThemeData.light(
      //         border: OutlineInputBorder(
      //             borderRadius: BorderRadius.all(Radius.circular(5))))),
      //   primaryColor: Colors.white,
      //   primarySwatch: Colors.grey,
      //   brightness: Brightness.light,
      //   backgroundColor: const Color(0xFFE5E5E5),
      //   dividerColor: Colors.white54,
      ),

  ThemeEnum.Dark: ThemeData.dark(),
  //   primaryColor: Colors.black,
  //   primarySwatch: Colors.grey,
  //   brightness: Brightness.dark,
  //   backgroundColor: const Color(0xFF212121),
  //   dividerColor: Colors.white12,
  // ),
};
