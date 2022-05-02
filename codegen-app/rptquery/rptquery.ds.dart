//Auto code generated from xml definition 2022-04-28 10:39:36.1596736 -0400 EDT
//RptQuery

import 'package:ez_search_ui/modules/rptquery/rptquery.model.dart';

/// Packages import
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RptQueryDataGridSource extends DataGridSource {
  late final List<RptQueryModel> ds;

  /// Creates the RptQuery data source class with required details.
  RptQueryDataGridSource(List<RptQueryModel> list) {
    ds = list;
    buildDataGridRows(list);
  }
  List<DataGridRow> _dataGridRows = <DataGridRow>[];
  static DateTime minDateTime = DateTime.utc(-271821, 04, 20);
  static DateTime maxDateTime = DateTime.utc(275760, 09, 13);

  /// Building DataGridRows
  void buildDataGridRows(List<RptQueryModel> list) {
    //print("side build data grid rows ${list.length}");
    _dataGridRows = list.map<DataGridRow>((RptQueryModel s) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<String>(columnName: 'name', value: s.name),
        DataGridCell<String>(columnName: 'division', value: s.division),
        DataGridCell<String>(columnName: 'page', value: s.page),
        DataGridCell<String>(columnName: 'cd', value: s.CustomData),
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
        child: Text(
          row.getCells()[0].value.toString(),
          softWrap: true,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          row.getCells()[0].value.toString(),
          softWrap: true,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          row.getCells()[0].value.toString(),
          softWrap: true,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          row.getCells()[0].value.toString(),
          softWrap: true,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          row.getCells()[0].value.toString(),
          softWrap: true,
        ),
      ),
    ]);
  }
}
