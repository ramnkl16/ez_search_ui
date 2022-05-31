import 'dart:convert';

import 'package:ez_search_ui/services/serviceLocator.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';
import 'package:http/http.dart' as http;

import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/common/rest_api_client.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/constants/app_messages.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/exceptions/custom_exception.model.dart';
import 'package:ez_search_ui/helper/RepoHelper.dart';

import 'package:ez_search_ui/modules/search/SearchResult.dart';

class SearchRepo {
  final RepoHelper repositoryHelper = RepoHelper();
  Future<SearchResult> getSearchData(String req) async {
    req = '{"q":"$req"}';
    //print("SearchCubit|getAllSearchs $req");
    var prefs = getIt<StorageService>();
    var token = await prefs.getAuthToken();
    var nsId = await prefs.getNamespace();
    // print("getsearchData| token $token nsId $nsId");
    if (token == null || nsId == null) {
      Global.pushLoginUnAuth();
      throw UnauthorizedException(message: AppValues.unAuthCubitMsg);
    }
    http.Response response =
        await RestClient.exeReq(RequestType.POST, ApiPaths.getSearch, req);

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var resBody = jsonDecode(response.body);
      SearchResult searchResult = SearchResult();

      // Map<String, dynamic> allFields = {};
      print("repo#40");
      List<Map<String, dynamic>> logsMaps = [];
      Map<String, Map<String, dynamic>> facetsData = {};
      if (resBody['resultRow'] != null) {
        resBody['resultRow'].forEach((element) {
          //print("#40|element $element");
          logsMaps.add(element);
        });
      }

      print("repo#50");
      if (resBody['facetResult'] != null) {
        var v = resBody['facetResult'] as Map<String, dynamic>;
        v.forEach((titleKey, titleValue) {
          Map<String, dynamic> list = <String, dynamic>{};
          for (var element in (titleValue as List<dynamic>)) {
            //print("#58 element| $element");
            String k = '';
            dynamic count;
            (element as Map<String, dynamic>).forEach((key, value) {
              if (key == "term") {
                k = value;
              }
              if (key == "count") {
                count = value;
              }
              // print("facetMap[key]| title=$titleKey| key=$key $value");
            });
            list[k] = count;
            // print("facetMap[key]| title=$titleKey| key=$k $count");
          }
          facetsData[titleKey] = list;
          //print("titleKey $titleKey $list ${list.length}");
        });
      }
      searchResult.facetResult = facetsData;
      //print(resBody['facetResult']);
      //print(logsMaps.toString());
      searchResult.resultRow = logsMaps;
      searchResult.total = resBody['total'];
      searchResult.took = resBody['took'];
      searchResult.fields = <String>[];
      //print("repo#82 ${resBody["fields"]}");
      for (var f in resBody["fields"]) {
        //print("repo#84 $f");
        searchResult.fields?.add(f);
      }
//        searchResult.status = Status.fromJson(resBody['status']);

      return searchResult;
      // } else {
      //   return 'Status Code: ${response.statusCode} \nError: ${response.body}';
    }
    //Response code is not successful
    repositoryHelper.handleAPIErrors(response);
    //print("repo#95| ");
    throw Exception(AppMessages.unknownErrMsg);
  }
}
