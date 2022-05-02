import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/main.dart';

class UtilFunc {
  static Future<void> clearHydratedStorage() async {
    var storage = getIt<HydratedStorage>();
    await storage.clear();
  }

  static Future<void> clearSharedStorage() async {
    var storage = await SharedPreferences.getInstance();
    storage.clear();
  }

  static String getAuthToken({String key = "x-auth"}) {
    var storage = getIt<SharedPreferences>();
    print('get namespace started');
    Object? str = storage.get(SharedPrefKeys.x_auth);
    if (str != null) {
      return str as String;
    }
    return "";
  }

  static String getNamespace({String key = "nsid"}) {
    var storage = getIt<SharedPreferences>();
    print('get namespace started');
    Object? str = storage.get(SharedPrefKeys.nsID);
    if (str != null) {
      return str as String;
    }
    return "";
  }

  static String getDefaultConnection({String key = "default"}) {
    var storage = getIt<SharedPreferences>();
    print('getDefaultConnection started');
    Object? str = storage.get(SharedPrefKeys.apiConns);
    if (str != null) {
      var jsonObj = jsonDecode(str as String);
      return jsonObj[key];
    }
    print(
        'getDefaultConnection end ${storage.getKeys()} ${storage.get('default')}');
    return "";
  }

  static void setConnection(String key, String connString) {
    var storage = getIt<SharedPreferences>();
    storage.getKeys();
    print('setConnection started');
    Object? str = storage.get(SharedPrefKeys.apiConns);
    dynamic jsonObj;
    if (str != null) {
      jsonObj = jsonDecode(str as String);
    } else {
      jsonObj = <String, String>{};
    }
    jsonObj[key] = connString;
    storage.setString(key, jsonEncode(jsonObj));
    print('setConnection completed ${storage.getKeys()}');
  }
}
