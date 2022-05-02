import 'package:http/http.dart' as http;
import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/constants/api_values.dart';
import 'package:ez_search_ui/constants/app_constant.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/exceptions/custom_exception.model.dart';
import 'package:ez_search_ui/helper/RepoHelper.dart';

class RestClient {
  //fetching token directly from shared resource
  static Future<http.Response> exeReq(
      RequestType method, String endPoint, dynamic body) async {
    print("exereq $endPoint");
    Uri uri = Uri.http(
      ApiPaths.baseURL,
      endPoint,
    );
    //String token, nsId = "";
    var token = await RepoHelper.getValue(ApiValues.authTokenHeader);
    var nsId = await RepoHelper.getValue(SharedPrefKeys.nsID);
    // var isSet =
    print('Inside restapiclient $endPoint');
    print(nsId);
    // print("Token is" + token!);
    if (token == null || nsId == null) {
      // return;
      Global.pushLoginUnAuth();
      throw UnauthorizedException(message: AppValues.unAuthCubitMsg);
    }

    print("${ApiPaths.baseURL} $endPoint :authtokent $token");
    switch (method) {
      case RequestType.GET:
        return http.get(uri, headers: {
          ApiValues.authTokenHeader: token,
          ApiValues.nsIdHeader: nsId,
          "Access-Control-Allow-Origin": "*"
        });
      case RequestType.POST:
        print(body);
        return http.post(uri,
            headers: {
              ApiValues.authTokenHeader: token,
              ApiValues.nsIdHeader: nsId,
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: body);
      case RequestType.DELETE:
        return http.delete(uri,
            headers: {
              ApiValues.authTokenHeader: token,
              ApiValues.nsIdHeader: nsId,
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: body);
      default:
        return throw Exception("The HTTP request method is not found");
    }
  }

  static Future<http.Response> exeuteReq(
      RequestType method, String endPoint, String authToken, dynamic body) {
    Uri uri = Uri.http(
      ApiPaths.baseURL,
      endPoint,
    );
    print("${ApiPaths.baseURL} $endPoint :authtokent $authToken");
    switch (method) {
      case RequestType.GET:
        return http.get(uri, headers: {
          ApiValues.authTokenHeader: authToken,
          "Access-Control-Allow-Origin": "*"
        });
      case RequestType.POST:
        return http.post(uri,
            headers: {
              ApiValues.authTokenHeader: authToken,
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: body);
      case RequestType.DELETE:
        return http.delete(uri,
            headers: {
              ApiValues.authTokenHeader: authToken,
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: body);
      default:
        return throw Exception("The HTTP request method is not found");
    }
  }
}

enum RequestType {
  GET,
  POST,
  DELETE,
  PUT,
}

extension RequestTypeExtension on RequestType {
  String get name {
    switch (this) {
      case RequestType.DELETE:
        return 'DELETE';
      case RequestType.POST:
        return 'MPOST';
      case RequestType.PUT:
        return "PUT";
      default:
        return "GET";
    }
  }
}
