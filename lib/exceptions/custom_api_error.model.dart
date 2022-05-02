import 'dart:convert';

class CustomAPIError {
  //String datetime;
  String errCode;
  String message;
  int status;

  CustomAPIError({
    //required this.datetime,
    required this.errCode,
    required this.message,
    required this.status,
  });

  factory CustomAPIError.fromMap(Map<String, dynamic> map) {
    return CustomAPIError(
      //datetime: map['datetime'] ?? '',
      errCode: map['error'] ?? "",
      message: map['message'] ?? '',
      status: map['status'] ?? 0,
    );
  }

  factory CustomAPIError.fromJson(String source) =>
      CustomAPIError.fromMap(json.decode(source));
}
