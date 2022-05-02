import 'dart:convert';

class LoginResponse {
  String authToken;
  String groupId;
  String namespaceId;
  LoginResponse({
    required this.authToken,
    required this.groupId,
    required this.namespaceId,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
        authToken: map['authToken'] ?? '',
        groupId: map['groupId'] ?? '',
        namespaceId: map['namespaceID'] ?? '');
  }

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source));
}
