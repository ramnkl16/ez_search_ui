//Auto code generated from xml definition 2022-05-03 19:54:23.8582221 -0400 EDT
//indexFields
import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/modules/indexes/indexes.cubit.dart';
import 'package:ez_search_ui/modules/indexfields/indexesFields.cubit.dart';
import 'package:ez_search_ui/modules/indexfields/indexfields.ds.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/modules/indexfields/indexfields.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_search_ui/common/global.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ez_search_ui/helper/UIhelper.dart';

class IndexFieldsPage extends StatefulWidget {
  const IndexFieldsPage({Key? key}) : super(key: key);

  @override
  _indexFieldsPageState createState() => _indexFieldsPageState();
}

class _indexFieldsPageState extends State<IndexFieldsPage> {
  late bool isWebOrDesktop;
  final DataGridController _dgController = DataGridController();
  List<String> list = [];

  /// Determine to decide whether the device in landscape or in portrait.
  late bool isLandscapeInMobileView;

  @override
  void initState() {
    BlocProvider.of<IndexFieldListCubit>(context)
        .getIndexeFields('data/b2b.bleve');

    isWebOrDesktop = Global.isWeb || Global.isDesktop;
    _dgController.selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildMenu(),
          BlocBuilder<IndexFieldListCubit, IndexState>(
            builder: (context, state) {
              print(state.runtimeType);
              if (state is IndexLoading) {
                return const CircularProgressIndicator();
              } else if (state is IndexFailure) {
                return Center(
                  child: Text(state.errorMsg),
                );
              } else if (state is IndexSuccess) {
                list = state.list;
                return _buildindexFieldsGrid();
              } else if (state is BaseEmpty) {
                return Text("No record found, Please create a indexFields");
              }
              return const Text("indexFields has unknown state");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return Row(
      children: [
        TextButton.icon(
            onPressed: () async {
              if (_dgController.selectedIndex == -1)
                _dgController.selectedIndex = 0;
              // var r =
              //     await showEditPageDialog(list[_dgController.selectedIndex]);
              setState(() {});
            },
            icon: const Icon(Icons.edit),
            label: const Text(MenuConstants.edit)),
        TextButton.icon(
            onPressed: () async {
              var m = createNewModel();

              // var r = await showEditPageDialog(m);
              // print(m);
              // if (r != null) {
              //   list.add(m);
              //   if (BlocProvider.of<IndexFieldListCubit>(context).state
              //       is BaseEmpty) {
              //     BlocProvider.of<IndexFieldListCubit>(context)
              //         .emitInitialSuccess(list);
              //   } else {
              //     setState(() {});
              //   }
              // }
            },
            icon: const Icon(Icons.add),
            label: const Text(MenuConstants.newVal)),
        TextButton.icon(
            onPressed: () {
              var sn = list[_dgController.selectedIndex];
              var rest = showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text("Delete indexFields $sn"),
                  content:
                      const Text('After deletion you can not retrive it back!'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              //perform delete api and remove item from the list
            },
            icon: const Icon(Icons.delete),
            label: const Text(MenuConstants.deleteVal))
      ],
    );
  }

  // Future<dynamic> showEditPageDialog(IndexFieldModel model) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           alignment: Alignment.center,
  //           // children: [indexFieldsEditPage()],
  //           content: SizedBox(
  //               width: MediaQuery.of(context).size.width - 100,
  //               height: MediaQuery.of(context).size.height - 100,
  //               child: BlocProvider(
  //                 create: (context) => indexFieldsEditCubit(),
  //                 child: indexFieldsEditPage(
  //                   in: model,
  //                 ),
  //               )),
  //           // title: Text('data'),
  //         );
  //       });
  // }

  Widget _buildindexFieldsGrid() {
    return Padding(
      padding: EdgeInsets.all(AppValues.sfGridPadding),
      child: SfDataGrid(
          allowSorting: true,
          source: indexFieldsDataGridSource(list),
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
          ]),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  IndexFieldModel createNewModel() {
    return IndexFieldModel(
      name: '',
    );
  }
}
