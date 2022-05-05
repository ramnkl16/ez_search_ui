//Auto code generated from xml definition 2022-04-28 10:39:36.1586205 -0400 EDT
//RptQuery
import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/helper/UIHelper.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.cubit.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.ds.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RptQueryPage extends StatefulWidget {
  const RptQueryPage({Key? key}) : super(key: key);

  @override
  _RptQueryPageState createState() => _RptQueryPageState();
}

class _RptQueryPageState extends State<RptQueryPage> {
  late bool isWebOrDesktop;
  final DataGridController _dgController = DataGridController();
  List<RptQueryModel> list = <RptQueryModel>[];

  /// Determine to decide whether the device in landscape or in portrait.
  late bool isLandscapeInMobileView;

  @override
  void initState() {
    BlocProvider.of<RptQueryCubit>(context).getAll();

    isWebOrDesktop = Global.isWeb || Global.isDesktop;
    _dgController.selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<RptQueryCubit, BaseState>(
            builder: (context, state) {
              print(state.runtimeType);
              if (state is BaseLoading) {
                return const CircularProgressIndicator();
              } else if (state is BaseFailure) {
                return Center(
                  child: Text(state.errorMsg),
                );
              } else if (state is BaseListSuccess<RptQueryModel>) {
                list = state.list;
                return _buildRptQueryGrid();
              } else if (state is BaseEmpty) {
                return Text("No record found, Please create a RptQuery");
              }
              return const Text("RptQuery has unknown state");
            },
          ),
        ],
      ),
    );
  }

  // Future<dynamic> showEditPageDialog(RptQueryModel model) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           alignment: Alignment.center,
  //           // children: [RptQueryEditPage()],
  //           content: SizedBox(
  //               width: MediaQuery.of(context).size.width - 100,
  //               height: MediaQuery.of(context).size.height - 100,
  //               child: BlocProvider(
  //                 create: (context) => RptQueryEditCubit(),
  //                 child: RptQueryEditPage(
  //                   rp: model,
  //                 ),
  //               )),
  //           // title: Text('data'),
  //         );
  //       });
  // }

  Widget _buildRptQueryGrid() {
    return Padding(
      padding: EdgeInsets.all(AppValues.sfGridPadding),
      child: SfDataGrid(
          allowSorting: true,
          source: RptQueryDataGridSource(list),
          selectionMode: SelectionMode.single,
          allowPullToRefresh: true,
          navigationMode: GridNavigationMode.cell,
          controller: _dgController,

          // onSelectionChanging: (addedRows, removedRows) {

          // },
          onCellTap: (DataGridCellDetails details) async {
            _dgController.selectedIndex = details.rowColumnIndex.rowIndex - 1;
            // if (details.rowColumnIndex.columnIndex == 0) {
            //   await showEditPageDialog(list[_dgController.selectedIndex]);
            //   setState(() {});
            //   _dgController.selectedIndex = details.rowColumnIndex.rowIndex;
            // }
          },
          columnWidthMode: isWebOrDesktop
              ? (isWebOrDesktop && Global.isMobileResolution)
                  ? ColumnWidthMode.none
                  : ColumnWidthMode.fill
              : isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.none,
          columns: <GridColumn>[
            UIHelper.buildGridColumn(label: 'Name', columnName: 'name'),
            UIHelper.buildGridColumn(label: 'Division', columnName: 'division'),
            UIHelper.buildGridColumn(label: 'Page', columnName: 'page'),
            UIHelper.buildGridColumn(label: 'Custom Data', columnName: 'cd'),
          ]),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  RptQueryModel createNewModel() {
    return RptQueryModel(
      id: '',
      name: '',
      division: '',
      page: '',
      CustomData: '',
    );
  }
}
