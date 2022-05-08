import 'dart:convert';

import 'package:ez_search_ui/services/serviceLocator.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/main.dart';

class UtilFunc {
  static Future<void> clearHydratedStorage() async {
    var storage = getIt<HydratedStorage>();
    await storage.clear();
  }

  // static Future<void> clearSharedStorage() async {
  //   var storage = await SharedPreferences.getInstance();
  //   storage.clear();
  // }

  // static Future<String> getAuthToken({String key = "x-auth"}) async {
  //   var storage = getIt<StorageService>();
  //   print('get namespace started');
  //   Object? str = await storage.getAuthToken();
  //   if (str != null) {
  //     return str as String;
  //   }
  //   return "";
  // }

  // static String getNamespace({String key = "nsid"}) {
  //   var storage = getIt<StorageService>();
  //   print('get namespace started');
  //   Object? str = storage.getNamespace();
  //   if (str != null) {
  //     return str as String;
  //   }
  //   return "";
  // }

  // static Future<String?> getDefaultConnection({String key = "default"}) async {
  //   var storage = getIt<StorageService>();
  //   print('getDefaultConnection started');
  //   String? str = await storage.getApiActiveConn();
  //   if (str != null) {
  //     return str;
  //   }
  //   return "";
  // }

}
