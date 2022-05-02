import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ez_search_ui/common/rest_api_client.dart';
import 'package:ez_search_ui/constants/api_values.dart';
import 'package:ez_search_ui/helper/RepoHelper.dart';

class BaseRepo {
  final RepoHelper repositoryHelper = RepoHelper();

  Future<List<T>> getAllList<T>(
      String relativeUrl, T Function(Map<String, dynamic>) jsonDeserialize,
      {Map<String, T>? globalValues}) async {
    http.Response response =
        await RestClient.exeReq(RequestType.GET, relativeUrl, null);
    print("BaseRepo $relativeUrl, ${response.body}");
    if (response.statusCode == HttpStatus.ok) {
      var jsonResp = jsonDecode(response.body);

      List<T> result = [];

      for (var item in jsonResp) {
        var res = jsonDeserialize(item);
        // print("jsonresp $res|item=$item");
        if (globalValues != null) {
          globalValues[item["id"]] = res;
        }
        result.add(res);
      }
      return result;
    }

    repositoryHelper.handleAPIErrors(response);

    throw Exception("Unknown Error");
  }

  Future<String?> createOrUpdate(
      String relativeUrl, Map<String, dynamic> body) async {
    http.Response response = await RestClient.exeReq(
        RequestType.POST, relativeUrl, jsonEncode(body));
    if (response.statusCode == HttpStatus.ok) {
      var jsonResp = jsonDecode(response.body);
      String? res = jsonResp[ApiValues.dataVal]['id'];
      return res;
    }
    repositoryHelper.handleAPIErrors(response);
    throw Exception("Unknown Error");
  }
}
