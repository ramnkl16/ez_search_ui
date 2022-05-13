import 'package:auto_route/auto_route.dart';
import 'package:ez_search_ui/helper/commondropdown.dart';
import 'package:ez_search_ui/modules/home/themenotifier.dart';
import 'package:ez_search_ui/services/serviceLocator.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';
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
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<NavigatorState> globalKey = GlobalKey();
  late final ThemeModel themeNotifier;
  String selectedColor = "Light";
  List<String> themeColors = ["Light", "Dark"];
  List<String> list = [];

  String curItem = '';

  final fn = FocusNode();

  @override
  void initState() {
    BlocProvider.of<AuthenticationCubit>(context).checkAuthenticationStatus();
    //print("default connection ${UtilFunc.getDefaultConnection()}");

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
        automaticallyImplyLeading: true,
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

  void dropDownDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.only(bottom: 600, left: 1075),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            content: Container(height: 60, child: ApiConnDropDownWidget()),
          );
        });
  }

  void themeDropDownDialog() {
    print('themecolor');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.only(bottom: 600, left: 1075),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              content: Container(
                height: 60,
                child: buildThemeDropDown(),
              ));
        });
  }

  Container buildThemeDropDown() {
    return Container(
      height: 60,
      child: CommonDropDown(
        k: "selectedColor",
        uniqueValues: themeColors,
        lblTxt: "Theme",
        onChanged: (newVal) {
          print('buildThemeDropDown');
          ThemeModel().toggleTheme();
        },
        ddDataSourceNames: themeColors,
      ),
    );
  }

//action items for desktop
  Widget appBarRightSideActionD() {
    return Row(
      children: [
        Tooltip(
          padding: const EdgeInsets.all(5),
          height: 35,
          textStyle: const TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
          message: AppValues.themeLbl,
          child: InkWell(
            child: const Text(
              "Theme",
              style: TextStyle(fontSize: 14),
            ),
            onTap: () {
              setState(() {
                selectedItem(context, 0);
              });
            },
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Tooltip(
          padding: const EdgeInsets.all(5),
          height: 35,
          textStyle: const TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
          message: AppValues.apiConnLbl,
          child: InkWell(
            child: const Text(
              "localhost",
              style: TextStyle(fontSize: 14),
            ),
            onTap: () {
              setState(() {
                selectedItem(context, 1);
              });
            },
          ),
        ),
        Tooltip(
          //waitDuration: Duration(seconds: 1),
          //showDuration: Duration(seconds: 2),
          padding: const EdgeInsets.all(5),
          height: 35,
          textStyle: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 241, 212, 212),
              fontWeight: FontWeight.normal),
          message: AppValues.dataRefreshLbl,
          child: IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: () => selectedItem(context, 2)),
        ),
        Tooltip(
          padding: const EdgeInsets.all(5),
          height: 35,
          textStyle: const TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
          message: AppValues.signOutLbl,
          child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => selectedItem(context, 3)),
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
            InkWell(
              child: Text(
                "Theme",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.normal),
              ),
            ),
            //Icon(Icons.api_rounded, color: Colors.black),
            SizedBox(width: 7),
            Text(AppValues.themeLbl),
          ]),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(children: const [
            InkWell(
              child: Text(
                "localhost",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.normal),
              ),
            ),
            //Icon(Icons.api_rounded, color: Colors.black),
            SizedBox(width: 7),
            Text(AppValues.apiConnLbl),
          ]),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(children: const [
            Icon(Icons.data_saver_off_sharp, color: Colors.black),
            SizedBox(width: 7),
            Text(AppValues.dataRefreshLbl),
          ]),
        ),
        PopupMenuItem<int>(
          value: 3,
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
        print('Theme');
        themeDropDownDialog();
        print('object');
        break;
      case 1:
        print('Api configuration');
        dropDownDialog();

        break;
      case 2:
        // print('Data Refresh');
        UtilFunc.clearHydratedStorage();
        //UtilFunc.clearSharedStorage();
        AutoRouter.of(context).popAndPush(
            LoginRoute(redirectRoute: NavigationPath.homePageBase + "search"));
        break;
      case 3:
        print('logout');
        //UtilFunc.clearSharedStorage();
        AutoRouter.of(context).popAndPush(
            LoginRoute(redirectRoute: NavigationPath.homePageBase + "search"));
        break;
    }
  }

  void _getDropDownItems() {
    //print("_execSearchQuery() ${curRptQuery.CustomData} ${qTxtCtrl.text}");
    // print("_getIndexFields() | $dropDownList");
    BlocProvider.of<MenuCubit>(context).getAllListData(curItem);
  }

  BlocBuilder<MenuCubit, BaseState> buildNavDrawer() {
    return BlocBuilder<MenuCubit, BaseState>(
      builder: (context, state) {
        if (state is BaseLoading) {
          return const Drawer(
            child: CircularProgressIndicator(),
          );
        } else if (state is BaseFailure) {
          return Drawer(child: Text(state.errorMsg));
        } else if (state is BaseListSuccess) {
          // print('menu success');
          // print('menu success test');
          LinkedHashMap<String, MenuModel> menus =
              LinkedHashMap<String, MenuModel>();

          List<String> addedVals = [];
          // LinkedHashMap.fromIterable(state.menus,
          //     key: (m) => (m as MenuPermission).id, value: (m) => m);
          //print("BuildNavDrawer|element ");
          for (var element in state.list) {
            // print("BuildNavDrawer|element $element");
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
                    // print(AutoRouter.of(context).current.path);
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
        return const Drawer(
          child: Text("No menu is defined"),
        );
      },
    );
  }
}

class ApiConnDropDownWidget extends StatelessWidget {
  @override
  Widget build(context) {
    return FutureBuilder(
        future: getApiConnList(),
        builder: (context, AsyncSnapshot<List<String>?> list) {
          if (list.hasData) {
            return Container(
              height: 60,
              child: CommonDropDown(
                k: "connList",
                uniqueValues: list.data!,
                lblTxt: "Localhost",
                onChanged: (String? val) async {
                  if (val != null) {
                    var prefs = getIt<StorageService>();
                    await prefs.setApiActiveConn(val);
                  }
                },
                ddDataSourceNames: list.data!,
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<List<String>?> getApiConnList() async {
    var prefs = getIt<StorageService>();
    print("getApiConnList|testing");
    List<String>? connList;
    connList = await prefs.getApiConnColl();
    print("getApiConnList|after get api conn $connList");
    return connList;
  }
}
