import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/api_values.dart';
import 'package:ez_search_ui/exceptions/custom_api_error.model.dart';

import '../exceptions/custom_exception.model.dart';

class RepoHelper {
  void handleAPIErrors(http.Response response) {
    //"ezsearch.statusCode ${response.statusCode}");
    switch (response.statusCode) {
      case HttpStatus.badRequest:
        CustomAPIError errResp = CustomAPIError.fromJson(response.body);
        throw BadRequestException(
            errorCode: errResp.errCode, message: errResp.message);
      case HttpStatus.internalServerError:
        throw InternalServerException(message: ApiValues.serverErrMsg);
      //TODO: actual 404 page not found need to be implemented
      case HttpStatus
          .notFound: //Refactor for   static const int noRecordFoundStatus = 452; by adding correctly from rest api
        print("not found ${response.body}");
        CustomAPIError errResp = CustomAPIError.fromJson(response.body);
        throw NoDataFoundException(message: errResp.message);

      case HttpStatus.unauthorized:
        CustomAPIError errResp = CustomAPIError.fromJson(response.body);
        // var router = getIt<AppRouter>();

        // var path = router.topMatch.path;
        // print("Repo helper reached");

        // print("Unauthorized");
        // // router.replaceAll([LoginRoute()]);
        // if (path != NavigationPath.loginPageBase) {
        //   router.navigate(
        //       LoginRoute(redirectRoute: NavigationPath.homePageBase + path));
        // }
        Global.pushLoginUnAuth();
        break;
      // throw UnauthorizedException(message: errResp.errorDesc);
      case ApiValues.noRecordFoundStatus:
        CustomAPIError errResp = CustomAPIError.fromJson(response.body);
        // if (errResp.errCode == ApiValues.emptyDataErrCode) {
        throw NoDataFoundException(message: errResp.message);
      // }
      default:
        throw Exception("Unknown Error");
    }
  }

  //To get a string value stored in shared preferences
  static Future<String?> getValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.getString(key);
    return res;
  }

  static Future<bool> setValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = prefs.setString(key, value);
    return res;
  }
}
