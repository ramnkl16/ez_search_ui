//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:ez_search_ui/constants/app_colors.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/constants/hex_color.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:io';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' show Workbook, Worksheet;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:convert';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:syncfusion_flutter_pdf/pdf.dart';

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

  Future<void> exportDataGridToPdf(GlobalKey<SfDataGridState> key) async {
    final PdfDocument document = key.currentState!.exportToPdfDocument();

    final List<int> bytes = document.save();
    File('DataGrid.pdf').writeAsBytes(bytes);
    document.dispose();

    File('DataGrid.pdf').writeAsBytes(bytes, flush: true);

    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'DataGrid.pdf')
        ..click();
    } else {
      final String path = (await getApplicationDocumentsDirectory()).path;
      final String fileName =
          Platform.isWindows ? '$path\\DataGrid.pdf' : '$path/DataGrid.pdf';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
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

  Future<void> createExcel(key) async {
    final Workbook workbook = key.currentState!.exportToExcelWorkbook();
    final Worksheet worksheet = workbook.worksheets[0];
    key.currentState!.exportToExcelWorksheet(worksheet);
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    File('DataGrid.xlsx').writeAsBytes(bytes, flush: true);

    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'DataGrid.xlsx')
        ..click();
    } else {
      final String path = (await getApplicationDocumentsDirectory()).path;
      final String fileName =
          Platform.isWindows ? '$path\\DataGrid.xlxs' : '$path/DataGrid.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
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
          color: color,
        ),
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
        decoration: BoxDecoration(
          color: Color.fromARGB(240, 205, 208, 211),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 8,
              // spreadRadius: UIConstants.shadowSpreadRadius,
              // offset:
              //     Offset(0.0, 1.0), // shadow direction: bottom right
            )
          ],
        ),
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
              color: Colors.red,
              onPressed: onPressed ?? () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              thickness: 2,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
