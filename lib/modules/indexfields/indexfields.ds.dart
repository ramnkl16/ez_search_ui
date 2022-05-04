//Auto code generated from xml definition 2022-05-03 19:54:23.8592582 -0400 EDT
//indexFields

import 'package:ez_search_ui/modules/indexfields/indexfields.model.dart';


/// Packages import
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class indexFieldsDataGridSource extends DataGridSource {
  late final List<IndexFieldModel> ds;

  /// Creates the indexFields data source class with required details.
  indexFieldsDataGridSource(List<IndexFieldModel> list) {
    ds = list;
    buildDataGridRows(list);
  }
  List<DataGridRow> _dataGridRows = <DataGridRow>[];
  static DateTime minDateTime = DateTime.utc(-271821, 04, 20);
  static DateTime maxDateTime = DateTime.utc(275760, 09, 13);

  /// Building DataGridRows
  void buildDataGridRows(List<IndexFieldModel> list) {
    //print("side build data grid rows ${list.length}");
    _dataGridRows = list.map<DataGridRow>((IndexFieldModel s) {
      return DataGridRow(cells: <DataGridCell>[ 
       DataGridCell<String>(columnName: 'name', value: s.name),
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
    ]);
  }
}
