//Auto code generated from xml definition 2022-04-28 10:39:36.1533026 -0400 EDT
//User

import 'package:ez_search_ui/modules/user/user.model.dart';

/// Packages import
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserDataGridSource extends DataGridSource {
  late final List<UserModel> ds;

  /// Creates the User data source class with required details.
  UserDataGridSource(List<UserModel> list) {
    ds = list;
    buildDataGridRows(list);
  }
  List<DataGridRow> _dataGridRows = <DataGridRow>[];
  static DateTime minDateTime = DateTime.utc(-271821, 04, 20);
  static DateTime maxDateTime = DateTime.utc(275760, 09, 13);

  /// Building DataGridRows
  void buildDataGridRows(List<UserModel> list) {
    //print("side build data grid rows ${list.length}");
    _dataGridRows = list.map<DataGridRow>((UserModel s) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<String>(columnName: 'name', value: s.name),
        DataGridCell<String>(columnName: 'firstName', value: s.firstName),
        DataGridCell<String>(columnName: 'lastName', value: s.lastName),
        DataGridCell<String>(columnName: 'email', value: s.email),
        DataGridCell<String>(columnName: 'mobile', value: s.mobile),
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
