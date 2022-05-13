import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppValues {
  static const int unknowErrorCode = 99;

  static const String unAuthCubitMsg =
      'User is unauthenticated. Reason: Session Expired';
  static const String authCubitMsg = 'User is Authenticated';

  static const String read = 'Read';
  static const String update = 'Update';
  static const String create = 'Create';
  static const String delete = 'Delete';
  static const String inheritance = 'Inheritance';
  static const String label = 'Generate';

  static const String hhmmaDtFmt = 'hh:mm a';
  static const double tabScreenWidth = 600;
  static const double slotCalendartHeight = 65;
  static const double slotCalendartHeaderHeight = 60;
  static const double slotCalendarWidth = 250;
  static const double timeRegionWidth = 80;
  static const double slotBookedBarWidth = 5;

  static List<TextInputFormatter> decimalPriceInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
  ];

  static const hexClrRegexPtrn = r'^#[0-9A-F]{6}$';

  static const double typeColorCntrSize = 20;

  static const double loginWidgetWidth = 350;

  static const double loginWidgetHeight = 20;

  static const double listBntWidgetWidth = 10;

  static const double listWrapWidgetWidth = 80;

  static const double layoutChangeMsxWidth = 500;

  static double getFormFieldWidth(double screenWidth) {
    return screenWidth > AppValues.layoutChangeMsxWidth
        ? screenWidth / 2 - 32
        : screenWidth;
  }

  static double getOprHrsWidth(double screenWidth) {
    return screenWidth > 900 ? screenWidth / 2 - 32 : screenWidth;
  }

  static const EdgeInsetsGeometry formFieldPadding = EdgeInsets.all(8);

  static const Color formCancelBtnColor = Colors.blueGrey;

  static const Color activeColor = Color.fromARGB(255, 52, 163, 24);

  static const trackColor = Color.fromARGB(242, 233, 11, 11);

  static const double sfGridPadding = 8;

  static const String defOprHr = "540-1260";
  // static const double formFieldPaddin

  static const String themeLbl = 'Theme';
  static const String apiConnLbl = 'Localhost';
  static const String dataRefreshLbl = 'Data Refresh';
  static const String signOutLbl = 'Sign Out';
  static const int desktopBreakPoint = 640;
  static const String homePageTitleLbl = 'Gost search';
  static const String unknowStateLbl = 'unknown state';
  static const String noRecFoundExpLbl = 'No record found.';
}
