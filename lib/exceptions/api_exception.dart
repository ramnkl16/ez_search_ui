class APIException implements Exception {
  final String errorDesc;
  final int status;
  final String errorCode;
  final String dateTime;
  APIException(
      {required this.status,
      required this.errorCode,
      required this.dateTime,
      required this.errorDesc});

  @override
  String toString() {
    return "Status: $status, ErrorCode: $errorCode, Error Description: $errorDesc, Datetime: $dateTime";
  }
}
