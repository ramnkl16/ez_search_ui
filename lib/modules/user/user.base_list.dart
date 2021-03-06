//Auto code generated from xml definition 2022-04-28 10:39:36.1512244 -0400 EDT
//User

import 'package:ez_search_ui/common/base_cubit.dart';
import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/helper/UIHelper.dart';
import 'package:ez_search_ui/modules/user/user.ds.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/modules/user/user.model.dart';
import 'package:ez_search_ui/modules/user/user.cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late bool isWebOrDesktop;
  final DataGridController _dgController = DataGridController();
  List<UserModel> list = <UserModel>[];

  /// Determine to decide whether the device in landscape or in portrait.
  late bool isLandscapeInMobileView;

  @override
  void initState() {
    BlocProvider.of<UserListCubit>(context).getAll();

    isWebOrDesktop = Global.isWeb || Global.isDesktop;
    _dgController.selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<UserListCubit, BaseState>(
            builder: (context, state) {
              print(state.runtimeType);
              if (state is BaseLoading) {
                return const CircularProgressIndicator();
              } else if (state is BaseFailure) {
                return Center(
                  child: Text(state.errorMsg),
                );
              } else if (state is BaseListSuccess<UserModel>) {
                list = state.list;
                //print("UserListCubit|success $list");
                return _buildUserGrid();
              } else if (state is BaseEmpty) {
                return Text("No record found, Please create a User");
              }
              return const Text("User has unknown state");
            },
          ),
        ],
      ),
    );
  }

  // Future<dynamic> showEditPageDialog(UserModel model) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           alignment: Alignment.center,
  //           // children: [UserEditPage()],
  //           content: SizedBox(
  //               width: MediaQuery.of(context).size.width - 100,
  //               height: MediaQuery.of(context).size.height - 100,
  //               child: BlocProvider(
  //                 create: (context) => UserEditCubit(),
  //                 child: UserEditPage(
  //                   us: model,
  //                 ),
  //               )),
  //           // title: Text('data'),
  //         );
  //       });
  // }

  Widget _buildUserGrid() {
    return Padding(
      padding: EdgeInsets.all(AppValues.sfGridPadding),
      child: Container(
        height: 450,
        child: SfDataGrid(
            allowSorting: true,
            source: UserDataGridSource(list),
            selectionMode: SelectionMode.single,
            allowPullToRefresh: true,
            navigationMode: GridNavigationMode.cell,
            controller: _dgController,

            // onSelectionChanging: (addedRows, removedRows) {

            // },
            onCellTap: (DataGridCellDetails details) async {
              _dgController.selectedIndex = details.rowColumnIndex.rowIndex - 1;
              if (details.rowColumnIndex.columnIndex == 0) {
                // await showEditPageDialog(list[_dgController.selectedIndex]);
                // setState(() {});
                // _dgController.selectedIndex = details.rowColumnIndex.rowIndex;
              }
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
              UIHelper.buildGridColumn(
                  label: 'First Name', columnName: 'firstName'),
              UIHelper.buildGridColumn(
                  label: 'Last Name', columnName: 'lastName'),
              UIHelper.buildGridColumn(label: 'Email', columnName: 'email'),
              UIHelper.buildGridColumn(label: 'Mobile', columnName: 'mobile'),
            ]),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  UserModel createNewModel() {
    return UserModel(
      id: '',
      name: '',
      firstName: '',
      lastName: '',
      email: '',
      mobile: '',
    );
  }
}
