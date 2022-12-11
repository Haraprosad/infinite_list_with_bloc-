
import 'dart:io';
import 'package:flutter_infinite_list/app/network/exceptions/base_api_exceptions/base_api_exception.dart';

class UnauthorizedException extends BaseApiException{
  UnauthorizedException(String message)
      :super(httpCode: HttpStatus.unauthorized, message: message, status: "unauthorized");
}