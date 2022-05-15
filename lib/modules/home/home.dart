import 'package:auto_route/auto_route.dart';
import 'package:ez_search_ui/helper/commondropdown.dart';
import 'package:ez_search_ui/modules/theme/configtheme.dart';
import 'package:ez_search_ui/modules/theme/themenotifier.dart';
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
  late double screenWidth;

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
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(AppValues.homePageTitleLbl),
        actions: [
          if (MediaQuery.of(context).size.width >= AppValues.desktopBreakPoint)
            appBarRightSideActionWiderScreen(),
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

  void _apiConnDropDownDialog() {
    print('apidropdown');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              //insetPadding: const EdgeInsets.only(bottom: 600, left: 1075),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              content: ApiConnDropDownWidget());
        });
  }

  void _themeDropDownDialog() {
    print('themecolor');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.topRight,
            child: AlertDialog(
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                //insetPadding: const EdgeInsets.only(bottom: 600, left: 1075),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                content: buildThemeDropDown()),
          );
        });
  }

  List<DropdownMenuItem<String>>? _getThems() {
    List<DropdownMenuItem<String>>? list = <DropdownMenuItem<String>>[];
    for (var item in ThemeEnum.values) {
      print("themeitem ${item.name}");
      list.add(
          DropdownMenuItem<String>(value: item.name, child: Text(item.name)));
    }
    print("themeitem len${list.length} $list");
    return list;
  }

  Widget buildThemeDropDown() {
    return DropdownButton<String>(
      value: ThemeNotifier.ezCurThemeName.name,
      icon: const Icon(Icons.arrow_downward),
      onChanged: (String? val) async {
        if (val != null) {
          ThemeEnum theme;
          switch (val) {
            case "Light":
            case "White":
              theme = ThemeEnum.White;
              break;

            default:
              theme = ThemeEnum.Dark;
              break;
          }
          await getIt<ThemeNotifier>().setTheme(theme);
          dismissDialog(context);
          setState(() {});
        }
      },
      items: _getThems(),
    );
  }

//action items for desktop
  Widget appBarRightSideActionWiderScreen() {
    return Row(
      children: [
        InkWell(
          child: Text(
            ThemeNotifier.ezCurThemeName.name,
            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.normal),
          ),
          onTap: () {
            setState(() {
              _setSelectedItemForRightSideAction(context, 0);
            });
          },
        ),
        const SizedBox(
          width: 15,
        ),
        InkWell(
          child: Text(ApiPaths.baseURLName.split('|')[0]),
          onTap: () {
            setState(() {
              _setSelectedItemForRightSideAction(context, 1);
            });
          },
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
              onPressed: () => _setSelectedItemForRightSideAction(context, 2)),
        ),
        Tooltip(
          padding: const EdgeInsets.all(5),
          height: 35,
          textStyle: const TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
          message: AppValues.signOutLbl,
          child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _setSelectedItemForRightSideAction(context, 3)),
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
            value: 0, child: Text(ThemeNotifier.ezCurThemeName.name)),
        PopupMenuItem<int>(
          value: 1,
          child: AsyncApiTextWidget(),
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
      onSelected: (item) => _setSelectedItemForRightSideAction(context, item),
    );
  }

  _setSelectedItemForRightSideAction(BuildContext context, int item) {
    print('item ${item}');
    switch (item) {
      case 0:
        _themeDropDownDialog();
        break;
      case 1:
        print('apidropdown');
        _apiConnDropDownDialog();

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
            if (element.id == 'root')
              addedVals.add('search');
            else {
              addedVals.add(element.name);
            }
          }
          return Drawer(
            child: ListView.builder(
              itemBuilder: ((context, index) {
                return ListTile(
                  hoverColor:
                      ezThemeData[ThemeNotifier.ezCurThemeName]?.hoverColor,
                  //leading: icon != null ? Icon(icon) : Icon(Icons.deck_outlined),
                  title: Text(addedVals[index]),
                  trailing: Icon(Icons.arrow_forward_ios),
                  contentPadding: EdgeInsets.only(left: 20),
                  // child: ,
                  onTap: () {
                    // print(AutoRouter.of(context).current.path);
                    if (index == 0) {
                      AutoRouter.of(context).replaceNamed('search');
                    } else if (index == 1) {
                      AutoRouter.of(context).replaceNamed('user');
                    } else if (index == 2) {
                      AutoRouter.of(context).replaceNamed('query');
                    } else if (index == 3) {
                      AutoRouter.of(context).replaceNamed('indexes');
                    } else if (index == 4) {
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

dismissDialog(BuildContext context) {
  Navigator.pop(context);
}

class ApiConnDropDownWidget extends StatelessWidget {
  @override
  Widget build(context) {
    print('apiconnection');
    return FutureBuilder(
        future: getApiConnList(),
        builder: (context, AsyncSnapshot<List<String>?> list) {
          if (list.hasData) {
            print('apiconnection list.hasData');
            return DropdownButton<String>(
              value: ApiPaths.baseURLName,
              icon: const Icon(Icons.arrow_downward),
              onChanged: (String? val) async {
                if (val != null) {
                  var prefs = getIt<StorageService>();
                  await prefs.setApiActiveConn(val);
                  dismissDialog(context);
                }
              },
              items: list.data!.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
          } else {
            print('apiconnection else');
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

class AsyncApiTextWidget extends StatelessWidget {
  @override
  Widget build(context) {
    return FutureBuilder(
        future: getApiActiveName(),
        builder: (context, AsyncSnapshot<String?> name) {
          if (name.hasData) {
            return Container(
              width: 50,
              child: InkWell(
                  child: Text(name.data!),
                  onTap: () async {
                    ApiConnDropDownWidget();
                  }),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<String?> getApiActiveName() async {
    var prefs = getIt<StorageService>();
    print("getApiConnList|testing");
    String? connName;
    connName = await prefs.getApiActiveConn();
    print("getApiConnList|after get api conn $connName");
    if (connName != null) {
      var split = connName.split('|');
      return Future.value(split[0]);
    } else {
      return Future.value(null);
    }
  }
}
