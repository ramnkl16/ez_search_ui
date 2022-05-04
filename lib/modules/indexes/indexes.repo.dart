import 'dart:convert';

import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/common/rest_api_client.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/constants/api_values.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/constants/app_messages.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/exceptions/custom_exception.model.dart';
import 'package:ez_search_ui/helper/RepoHelper.dart';
import 'package:http/http.dart' as http;

class IndexRepo {
  final RepoHelper repositoryHelper = RepoHelper();
  Future<List<String>> getIndexes() async {
    //req = '{"q":"$req"}';
    //print("SearchCubit|getAllSearchs $req");
    var token = await RepoHelper.getValue(ApiValues.authTokenHeader);
    var nsId = await RepoHelper.getValue(SharedPrefKeys.nsID);
    print("getsearchData| token $token nsId $nsId");
    if (token == null || nsId == null) {
      Global.pushLoginUnAuth();
      throw UnauthorizedException(message: AppValues.unAuthCubitMsg);
    }
    http.Response response =
        await RestClient.exeReq(RequestType.GET, ApiPaths.ListIndexes, null);
    List<String> list = <String>[];
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var resBody = jsonDecode(response.body);

      resBody.forEach((element) {
        //print("#40|element $element");
        list.add(element);
      });
      return list;
    }
    //Response code is not successful
    repositoryHelper.handleAPIErrors(response);

    throw Exception(AppMessages.unknownErrMsg);
  }
}
