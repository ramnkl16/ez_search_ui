//import 'dart:html';

import 'package:ez_search_ui/modules/theme/configtheme.dart';
import 'package:ez_search_ui/modules/theme/themenotifier.dart';
import 'package:flutter/material.dart';
import 'package:ez_search_ui/constants/app_colors.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/constants/hex_color.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class UIHelper {
  static Widget buildPdfWidget(String label) {
    UIHelper ui = new UIHelper();
    return TextButton.icon(
      //style: TextButton.styleFrom(primary: Color(0xff1D6F42)),

      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xffF40F02)),
          shape: MaterialStateProperty.all(StadiumBorder())),
      onPressed: () {
        //ui.exportDataGridToPdf();
      },

      icon: Icon(
        MdiIcons.filePdfBox,
        color: AppColors.pdfXlsIconClr,
        //size: 125.0,
      ),
      label: Text(
        label,
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }

  static Widget buildXlsWidget(String label) {
    return TextButton.icon(
      //style: TextButton.styleFrom(primary: Color(0xff1D6F42)),
      // backgroundColor: ,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xff1D6F42)),
          shape: MaterialStateProperty.all(StadiumBorder())),

      onPressed: () {},
      // createExcel,

      icon: Icon(
        MdiIcons.microsoftExcel,
        color: AppColors.pdfXlsIconClr,
        //size: 125.0,
      ),
      label: Text(
        label,
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }

  static Widget buildColorDSWidget(String clrCode) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Container(
              width: AppValues.typeColorCntrSize,
              height: AppValues.typeColorCntrSize,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: HexColor(clrCode))),
          SizedBox(
            width: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              clrCode,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildRegGridElemt(String val) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: SelectableText(
        val,
        textAlign: TextAlign.left,
      ),
    );
  }

  static Widget buildGridIdElemt(String clr1) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(4.0),
              alignment: Alignment.centerLeft,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  clr1,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ],
      ),
    );
  }

  static Widget btnDecoration(String label, double screenWidth,
      {Color color = Colors.deepOrangeAccent, String toolTipMsg = ""}) {
    return Tooltip(
      message: toolTipMsg,
      child: Container(
        height: 30,
        width: AppValues.loginWidgetWidth + 32 < screenWidth
            ? AppValues.loginWidgetWidth
            : screenWidth - 32,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: ezThemeData[ThemeNotifier.ezCurThemeName]
                ?.colorScheme
                .tertiary),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO: get a parameter for icon
              if (label == AppConstants.cancelBtn)
                Icon(
                  Icons.cancel_rounded,
                  color: Colors.white,
                ),
              if (label == "Submit")
                Icon(
                  Icons.save_rounded,
                  color: Colors.white,
                ),
              SizedBox(
                width: 10,
              ),
              Text(
                label,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static GridColumn buildGridColumn(
      {required String label,
      required String columnName,
      isDefaultColor = true}) {
    return GridColumn(
      // columnWidthMode: ColumnWidthMode.auto,

      // columnWidthMode: ColumnWidthMode.fill,
      columnName: columnName,

      label: Container(
        //decoration: BoxDecoration(
        //   color:
        //       ezThemeData[ThemeNotifier.ezCurThemeName.name]?.primaryColorLight,
        //   // // boxShadow:  [
        //   // //   BoxShadow(
        //   // //      color: ezThemeData[ThemeNotifier.ezCurThemeName.name]?.primaryColorLight.value,
        //   // //     blurRadius: 8,
        //   // //     // spreadRadius: UIConstants.shadowSpreadRadius,
        //   // //     // offset:
        //   // //     //     Offset(0.0, 1.0), // shadow direction: bottom right
        //   // //   )
        //   // ],
        // ),
        padding: const EdgeInsets.all(4.0),
        alignment: Alignment.centerLeft,
        child: SelectableText(
          capitalize(label),
          //overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static GridColumn buildGridColumnFacets(
      {required String label,
      required String columnName,
      isDefaultColor = true}) {
    return GridColumn(
      // columnWidthMode: ColumnWidthMode.auto,

      // columnWidthMode: ColumnWidthMode.fill,
      columnName: columnName,

      label: Container(
        // decoration: BoxDecoration(
        //   // color: Color.fromARGB(240, 205, 208, 211),
        //   // boxShadow: const [
        //   //   BoxShadow(
        //   //     // color: Colors.white,
        //   //     blurRadius: 8,
        //   //     // spreadRadius: UIConstants.shadowSpreadRadius,
        //   //     // offset:
        //   //     //     Offset(0.0, 1.0), // shadow direction: bottom right
        //   //   )
        //   // ],
        // ),
        padding: const EdgeInsets.all(4.0),
        alignment: Alignment.centerLeft,
        child: Text(
          capitalize(label),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static Widget buildFormHeader(BuildContext context, String title,
      {Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            trailing: IconButton(
              icon: Icon(Icons.cancel_outlined),
              iconSize: 34,
              //color: Colors.red,
              onPressed: onPressed ?? () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              thickness: 2,
              // color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
