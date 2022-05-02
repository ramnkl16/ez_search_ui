import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_search_ui/constants/api_values.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/constants/navigation_path.dart';
import 'package:ez_search_ui/cubit/hydratedCubit.dart';
import 'package:ez_search_ui/helper/RepoHelper.dart';
import 'package:ez_search_ui/main.dart';
import 'package:ez_search_ui/modules/menu/menu.cubit.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.cubit.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.model.dart';
import 'package:ez_search_ui/modules/usermenu/usermenu.model.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import 'package:ez_search_ui/router/appRouter.gr.dart';

class Global {
  static late String namespaceId;
  static late String authToken;
  static Map<String, UserMenuModel> _userMenus = {};
  static Map<String, RptQueryModel> _indexQuery = {};

  static Map<String, UserMenuModel> get userMenus {
    return _userMenus;
  }

  static Map<String, RptQueryModel> get indexQueryies {
    return _indexQuery;
  }

  static loadBlocMetaDatas(BuildContext context) {
    BlocProvider.of<UserMenuListCubit>(context).getAll();
    BlocProvider.of<MenuCubit>(context).getAll();
    BlocProvider.of<RptQueryCubit>(context).getAll();
  }

  //TODO: if login is added, use this method to authenticate once session expired
  static pushLoginUnAuth() {
    var router = getIt<AppRouter>();

    var path = router.topMatch.path;
    print("Repo helper reached");

    print("Unauthorized");
    // router.replaceAll([LoginRoute()]);
    if (path != NavigationPath.loginPageBase) {
      router.navigate(
          LoginRoute(redirectRoute: NavigationPath.homePageBase + path));
    }
  }

  static Future<void> loadInitialMeta() async {
    print("loadInitialMeta is called");
    namespaceId = (await RepoHelper.getValue(SharedPrefKeys.nsID))!;
    authToken = (await RepoHelper.getValue(ApiValues.authTokenHeader))!;
  }

  //localization
  static late String languageCode;

  static bool isWebFullView = false;

  ///Check whether application is running on a mobile device
  static bool isMobile = false;

  ///Check whether application is running on the web browser
  static bool isWeb = false;

  ///Check whether application is running on the desktop
  static bool isDesktop = false;

  ///Check whether application is running on the Android mobile device
  static bool isAndroid = false;

  ///Check whether application is running on the Windows desktop OS
  static bool isWindows = false;

  ///Check whether application is running on the iOS mobile device
  static bool isIOS = false;

  ///Check whether application is running on the Linux desktop OS
  static bool isLinux = false;

  ///Check whether application is running on the macOS desktop
  static bool isMacOS = false;

  static late bool isMobileResolution;
  static bool isPropertyPanelOpened = true;
  static void initializeProperties() {
    isWebFullView =
        kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    if (kIsWeb) {
      isWeb = true;
      isMobileResolution = false;
    } else {
      isAndroid = Platform.isAndroid;
      isIOS = Platform.isIOS;
      isLinux = Platform.isLinux;
      isWindows = Platform.isWindows;
      isMacOS = Platform.isMacOS;
      isDesktop = Platform.isLinux || Platform.isMacOS || Platform.isWindows;
      isMobile = Platform.isAndroid || Platform.isIOS;

      isMobileResolution = Platform.isAndroid || Platform.isIOS;
    }
  }
}
