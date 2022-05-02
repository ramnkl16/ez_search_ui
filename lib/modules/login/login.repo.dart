import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ez_search_ui/constants/api_values.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/helper/RepoHelper.dart';

import 'login.reponse.model.dart';
import 'login.request.model.dart';
import 'login.provider.dart';

class LoginRepository {
  final LoginProvider loginProvider = LoginProvider();
  final RepoHelper repositoryHelper = RepoHelper();
  // final sharedPrefs = SharedPreferences.getInstance();

  Future<LoginResponse> authenticateUser(LoginRequest loginRequest) async {
    http.Response loginResponse = await loginProvider.loginUser(loginRequest);
    print("after post api call");
    print(loginResponse.statusCode);

    if (loginResponse.statusCode == HttpStatus.ok) {
      var jsonResp = jsonDecode(loginResponse.body);
      print("json resp $jsonResp");
      LoginResponse result = LoginResponse.fromMap(jsonResp);
      await storeAuthToken(ApiValues.authTokenHeader, result.authToken);
      await storeAuthToken(SharedPrefKeys.nsID, result.namespaceId);
      await storeAuthToken(SharedPrefKeys.grpID, result.groupId);
      await updateTokenTime(DateTime.now().toString());
      return result;
    } else {
      repositoryHelper.handleAPIErrors(loginResponse);
    }

    throw Exception("Unknown Error");
  }

  Future<bool> storeAuthToken(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await prefs.setString(key, value);
    // await prefs.setString(ApiValues.nsIDSharedPref, nsID);
    print("Stored key: $key with value: $value : ${res.toString()}");
    return res;
  }

  Future<bool> updateTokenTime(String dateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? time = prefs.getString(key);
    var time = await prefs.setString(ApiValues.authTokenTime, dateTime);
    print("Stored key time: " + time.toString());
    return time;
  }

  Future<bool> deleteToken(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var k = await prefs.remove(key);
    print("Stored key $key: $k");
    return k;
  }
}
