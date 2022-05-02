import 'dart:io';

import 'package:ez_search_ui/constants/api_values.dart';

class CustomException implements Exception {
  String message;
  int statusCode;
  String prefix;
  CustomException({
    required this.message,
    required this.statusCode,
    required this.prefix,
  });

  @override
  String toString() {
    return "$prefix $message";
  }
}

class BadRequestException extends CustomException {
  BadRequestException({required String message, required String errorCode})
      : super(
            statusCode: HttpStatus.badRequest,
            message: "$errorCode|$message",
            prefix: ApiValues.badReqErrPrefix);
}

class InternalServerException extends CustomException {
  InternalServerException({required String message})
      : super(
            statusCode: HttpStatus.internalServerError,
            message: message,
            prefix: ApiValues.serverErrPrefix);
}

class UnauthorizedException extends CustomException {
  UnauthorizedException({required String message})
      : super(
            statusCode: HttpStatus.badRequest,
            message: message,
            prefix: ApiValues.badReqErrPrefix);
}

class NotFoundException extends CustomException {
  NotFoundException({required String message})
      : super(
            statusCode: HttpStatus.notFound,
            message: message,
            prefix: ApiValues.notFoundErrMsg);
}

class NoDataFoundException extends CustomException {
  NoDataFoundException({required String message})
      : super(
            statusCode: HttpStatus.notFound,
            message: message,
            prefix: ApiValues.notFoundErrMsg);
}
