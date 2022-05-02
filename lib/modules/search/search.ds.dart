import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_search_ui/helper/UIHelper.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.model.dart';
import 'package:ez_search_ui/modules/search/SearchResult.dart';
//import 'package:ez_search_ui/modules/search/search.cubit.dart';
import 'package:ez_search_ui/modules/search/search.list.page.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Packages import
//part of 'search.list.page.dart';

class SearchDatagridSource extends DataGridSource {
  late RptQueryModel curRptQ;

  late final BuildContext ctx;
  Color backgroundColor = const Color.fromRGBO(0, 116, 227, 1);

  /// Creates the ScheduleException data source class with required details.
  SearchDatagridSource(
      RptQueryModel queryModel, BuildContext context, SearchResult result) {
    curRptQ = queryModel;
    ctx = context;
    buildDataGridRows();
  }
  List<DataGridRow> _dataGridRows = <DataGridRow>[];

  /// Building DataGridRows
  void buildDataGridRows() {
    _dataGridRows =
        result!.resultRow!.map<DataGridRow>((Map<String, dynamic> item) {
      //print("Build data gid rows $item");
      return DataGridRow(cells: _buildGridCell(item));
    }).toList(growable: true);
  }

  List<DataGridCell<dynamic>> _buildGridCell(Map<String, dynamic> values) {
    var cells = <DataGridCell<dynamic>>[];
    for (var element in result!.fields ?? [""]) {
      //print("Field Name| $element");
      cells.add(
          DataGridCell<dynamic>(columnName: element, value: values[element]));
    }
    //print("cells len ${cells.length}");
    return cells;
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
    if ((rowIndex % 2) == 0) {
      backgroundColor = backgroundColor.withOpacity(0.07);
    }

    return DataGridRowAdapter(
        color: backgroundColor, cells: _buildRowWidgetDs(row));
  }

  // void _execSearchQuery() {
  //   var startRow = curRptQ.pgStartIndex * curRptQ.pgSize;
  //   BlocProvider.of<SearchCubit>(ctx)
  //       .getAllSearchs(curRptQ.CustomData, startRow, curRptQ.pgSize);
  // }

  // @override
  // Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
  //   print(
  //       "Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {");
  //   if (oldPageIndex != newPageIndex) {
  //     curRptQ.pgStartIndex = newPageIndex;

  //     var startRow = curRptQ.pgStartIndex * curRptQ.pgSize;
  //     await BlocProvider.of<NavigationSearchCubit>(ctx)
  //         .getAllSearchs(curRptQ.CustomData, startRow, curRptQ.pgSize);
  //     var state = BlocProvider.of<NavigationSearchCubit>(ctx).state;
  //     // await Future<void>.delayed(const Duration(seconds: 5));
  //     if (state is SearchSuccess) {
  //       print("Search success in Navigation");
  //       print("Before calling notify");
  //       print(result!.resultRow!.first);
  //       //res = state.result;
  //       for (var item in state.result.resultRow!) {
  //         result!.resultRow!.add(item);
  //       }
  //       buildDataGridRows();
  //       // buildRow(row)

  //       notifyListeners();
  //       //notifyDataSourceListeners(rowColumnIndex: RowColumnIndex(1, 1));
  //     }

  //     return true;
  //   }
  //   return false;
  // }

  List<Widget> _buildRowWidgetDs(DataGridRow row) {
    var widgets = <Widget>[];
    var idx = 0;
    //print("_buildRowWidgetDs");
    for (var element in result!.fields!) {
      if (idx == 0) {
        print(row);
      }
      widgets.add(
          UIHelper.buildRegGridElemt(row.getCells()[idx].value.toString()));
      idx++;
    }
    return widgets;
  }

  // @override
  // Future<void> handleLoadMoreRows() async {
  //   await Future<void>.delayed(const Duration(seconds: 5));
  //   _execSearchQuery();
  //   // orders = getOrders(orders, 15);
  //   // buildDataGridRows();
  //   // notifyListeners();
  // }

  // @override
  // Future<void> handleRefresh() async {
  //   await Future<void>.delayed(const Duration(seconds: 5));
  //   // orders = getOrders(orders, 15);
  //   // buildDataGridRows();
  //   // notifyListeners();
  // }
}
