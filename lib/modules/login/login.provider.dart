import 'package:http/http.dart' as http;
import 'package:ez_search_ui/constants/api_endpoints.dart';

import 'login.request.model.dart';

class LoginProvider {
  Future<http.Response> loginUser(LoginRequest loginRequest) {
    print("LoginProvider|start");
    print(loginRequest.toJson());
    print("${ApiPaths.baseURL} ${ApiPaths.authLogin}");
    Uri url = Uri.http(
      ApiPaths.baseURL,
      ApiPaths.authLogin,
    );
    return http.post(url, body: loginRequest.toJson());
  }
}
