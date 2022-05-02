import 'dart:convert';

class LoginRequest {
  String emailOrMobile;
  String password;
  String nsCode;
  String connString;
  LoginRequest({
    required this.emailOrMobile,
    required this.password,
    required this.nsCode,
    required this.connString,
  });

  Map<String, dynamic> toMap() {
    return {
      'emailOrMobile': emailOrMobile,
      'password': password,
      'nsCode': nsCode,
      'connString': connString
    };
  }

  String toJson() => json.encode(toMap());
}
