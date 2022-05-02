import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_search_ui/helper/UIHelper.dart';
import 'package:ez_search_ui/modules/search/search.list.page.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class FacetDatagridSource extends DataGridSource {
  late Map<String, dynamic> data1;
  late String groupName;
  late DataGridController _dg;

  late final BuildContext ctx;
  Color backgroundColor = const Color.fromRGBO(0, 116, 227, 1);

  /// Creates the ScheduleException data source class with required details.
  FacetDatagridSource(
      Map<String, dynamic> list, String grpName, DataGridController dg) {
    data1 = list;
    groupName = grpName;
    _dg = dg;
    buildDataGridRows();
  }
  List<DataGridRow> _dataGridRows = <DataGridRow>[];

  /// Building DataGridRows
  void buildDataGridRows() {
    for (var item in data1.keys) {
      var dr = DataGridRow(cells: <DataGridCell>[
        DataGridCell<dynamic>(
            columnName: groupName, value: '$item(${data1[item]})')
      ]);
      _dataGridRows.add(dr);
      var key = '$groupName:$item';
      if (facetsFilter.keys.contains(key)) {
        _dg.selectedRows.add(dr);
      }
    }
  }

  // Overrides
  @override
  List<DataGridRow> get rows {
    //print('@override List<DataGridRow> get rows');
    return _dataGridRows;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = _dataGridRows.indexOf(row);
    Color backgroundColor = Colors.transparent;
    // if ((rowIndex % 2) == 0) {
    //   backgroundColor = backgroundColor.withOpacity(0.07);
    // }

    return DataGridRowAdapter(
        color: backgroundColor, cells: _buildRowWidgetFacet(row));
  }

  List<Widget> _buildRowWidgetFacet(DataGridRow row) {
    var widgets = <Widget>[];
    widgets.add(UIHelper.buildRegGridElemt(row.getCells()[0].value.toString()));
    return widgets;
  }
}
