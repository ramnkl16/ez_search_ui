//Auto code generated from xml definition 2022-05-03 19:54:23.854093 -0400 EDT
//Indexes

/// Packages import
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class IndexesDataGridSource extends DataGridSource {
  late final List<String> ds;

  /// Creates the Indexes data source class with required details.
  IndexesDataGridSource(List<String> list) {
    ds = list;
    buildDataGridRows(list);
  }
  List<DataGridRow> _dataGridRows = <DataGridRow>[];
  static DateTime minDateTime = DateTime.utc(-271821, 04, 20);
  static DateTime maxDateTime = DateTime.utc(275760, 09, 13);

  /// Building DataGridRows
  void buildDataGridRows(List<String> list) {
    //print("side build data grid rows ${list.length}");
    _dataGridRows = list.map<DataGridRow>((String s) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<String>(columnName: 'Index', value: s),
      ]);
    }).toList();
  }

  // Overrides
  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        child: SelectableText(
          row.getCells()[0].value.toString(),
        ),
      ),
    ]);
  }
}
