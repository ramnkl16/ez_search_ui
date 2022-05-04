import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_search_ui/common/base_cubit.dart';
import 'dart:collection';

import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/constants/navigation_path.dart';
import 'package:ez_search_ui/helper/RepoHelper.dart';
import 'package:ez_search_ui/helper/utilfunc.dart';

import 'package:ez_search_ui/modules/authentication/authentication.cubit.dart';
import 'package:ez_search_ui/modules/menu/menu.cubit.dart';
import 'package:ez_search_ui/modules/menu/menu.model.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.cubit.dart';
import 'package:ez_search_ui/modules/user/user.cubit.dart';
import 'package:ez_search_ui/router/appRouter.gr.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<NavigatorState> globalKey = GlobalKey();
  @override
  void initState() {
    BlocProvider.of<AuthenticationCubit>(context).checkAuthenticationStatus();
    print("default connection ${UtilFunc.getDefaultConnection()}");

    Global.loadBlocMetaDatas(context);
    performInitOperatons();
    // }
    super.initState();
  }

  performInitOperatons() async {
    var grpId = await RepoHelper.getValue(SharedPrefKeys.grpID);
    var nsId = await RepoHelper.getValue(SharedPrefKeys.nsID);
    if (nsId != null) {
      Global.namespaceId = nsId;
    }
    if (grpId == null || nsId == null) {
      BlocProvider.of<AuthenticationCubit>(context).emitUnAuthTokenExpired();
    }
    if (BlocProvider.of<MenuCubit>(context).state is! BaseListSuccess) {
      BlocProvider.of<MenuCubit>(context).getAllListData(ApiPaths.menuSearch);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppValues.homePageTitleLbl),
        actions: [
          if (MediaQuery.of(context).size.width >= AppValues.desktopBreakPoint)
            appBarRightSideActionD(),
          if (MediaQuery.of(context).size.width < AppValues.desktopBreakPoint)
            appBarRightSideAction(),
        ],
      ),
      drawer: buildNavDrawer(),
      body: MultiBlocProvider(
        providers: [
          // BlocProvider(
          //   create: (context) => MenuPermissionCubit(MenuPermissionRepo()),
          //   // lazy: false,
          // ),

          BlocProvider(
            create: (context) => UserListCubit(),
          ),
          BlocProvider(
            create: (context) => MenuCubit(),
          ),
          BlocProvider(
            create: (context) => RptQueryCubit(),
          ),
          BlocProvider(
            create: (context) => RptQuerySaveCubit(),
          ),
        ],
        child: BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            // if (state is UnAuthTokenExpired) {
            //   AutoRouter.of(context).replaceAll([LoginRoute()]);
            // }
          },
          child: AutoRouter(),
        ),
      ),
    );
  }

//action items for desktop
  Widget appBarRightSideActionD() {
    return Row(
      children: [
        Tooltip(
          padding: EdgeInsets.all(5),
          height: 35,
          textStyle: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
          message: AppValues.apiConnLbl,
          child: IconButton(
            icon: Icon(Icons.api_rounded),
            onPressed: () => selectedItem(context, 0),
          ),
        ),
        Tooltip(
          //waitDuration: Duration(seconds: 1),
          //showDuration: Duration(seconds: 2),
          padding: EdgeInsets.all(5),
          height: 35,
          textStyle: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
          message: AppValues.dataRefreshLbl,
          child: IconButton(
            icon: Icon(Icons.refresh_outlined),
            onPressed: () => selectedItem(context, 1),
          ),
        ),
        Tooltip(
          padding: EdgeInsets.all(5),
          height: 35,
          textStyle: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
          message: AppValues.signOutLbl,
          child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => selectedItem(context, 2)),
        ),
      ],
    );
  }

  Widget appBarRightSideAction() {
    return PopupMenuButton<int>(
      elevation: 20,
      enabled: true,
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Row(children: const [
            Icon(Icons.api_rounded, color: Colors.black),
            SizedBox(width: 7),
            Text(AppValues.apiConnLbl),
          ]),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(children: const [
            Icon(Icons.data_thresholding_outlined, color: Colors.black),
            SizedBox(width: 7),
            Text(AppValues.dataRefreshLbl),
          ]),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(children: const [
            Icon(Icons.logout, color: Colors.black),
            SizedBox(width: 7),
            Text(AppValues.signOutLbl),
          ]),
        ),
      ],
      onSelected: (item) => selectedItem(context, item),
    );
  }

  selectedItem(BuildContext context, int item) {
    switch (item) {
      case 0:
        print('Api configuration');
        break;
      case 1:
        print('Data Refresh');
        UtilFunc.clearHydratedStorage();
        UtilFunc.clearSharedStorage();
        AutoRouter.of(context).popAndPush(
            LoginRoute(redirectRoute: NavigationPath.homePageBase + "search"));
        break;
      case 2:
        print('logout');
        UtilFunc.clearSharedStorage();
        AutoRouter.of(context).popAndPush(
            LoginRoute(redirectRoute: NavigationPath.homePageBase + "search"));
        break;
    }
  }

  BlocBuilder<MenuCubit, BaseState> buildNavDrawer() {
    return BlocBuilder<MenuCubit, BaseState>(
      builder: (context, state) {
        if (state is BaseLoading) {
          return Drawer(
            child: const CircularProgressIndicator(),
          );
        } else if (state is BaseFailure) {
          return Drawer(child: Text(state.errorMsg));
        } else if (state is BaseListSuccess) {
          print('menu success');
          print('menu success test');
          LinkedHashMap<String, MenuModel> menus =
              LinkedHashMap<String, MenuModel>();

          List<String> addedVals = [];
          // LinkedHashMap.fromIterable(state.menus,
          //     key: (m) => (m as MenuPermission).id, value: (m) => m);
          print("BuildNavDrawer|element ");
          for (var element in state.list) {
            print("BuildNavDrawer|element $element");
            menus[element.id] = element;
            if (element.id != 'root') {
              addedVals.add(element.name);
            }
          }
          return Drawer(
            child: ListView.builder(
              itemBuilder: ((context, index) {
                return ListTile(
                  hoverColor: Colors.amber[200],
                  //leading: icon != null ? Icon(icon) : Icon(Icons.deck_outlined),
                  title: Text(addedVals[index]),
                  trailing: Icon(Icons.arrow_forward_ios),
                  contentPadding: EdgeInsets.only(left: 20),
                  // child: ,
                  onTap: () {
                    print(AutoRouter.of(context).current.path);
                    if (index == 0) {
                      AutoRouter.of(context).replaceNamed('user');
                    } else if (index == 1) {
                      AutoRouter.of(context).replaceNamed('query');
                    } else if (index == 2) {
                      AutoRouter.of(context).replaceNamed('indexes');
                    } else if (index == 3) {
                      AutoRouter.of(context).replaceNamed('fields');
                    }

                    // Navigator.pop(context);
                  },
                );
              }),
              itemCount: addedVals.length,
            ),
          );
        }
        print('menu nothing');
        return Drawer(
          child: const Text("No menu is defined"),
        );
      },
    );
  }
}
