import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ez_search_ui/common/rest_api_client.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/helper/RepoHelper.dart';
import 'package:ez_search_ui/modules/rptquery/rptquery.model.dart';

class RptQueryRepo {
  final RepoHelper repositoryHelper = RepoHelper();
  Future<String?> createOrUpdateQueryDef(RptQueryModel body) async {
    print("createorUpdate-rpt query ${body.toJson()}");
    http.Response response = await RestClient.exeReq(
        RequestType.POST, ApiPaths.rptQuerySave, body.toJson());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body.id;
    }
    repositoryHelper.handleAPIErrors(response);
    throw Exception("Unknown Error");
  }
}
