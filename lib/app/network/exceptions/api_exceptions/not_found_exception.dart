
import 'dart:io';
import 'package:flutter_infinite_list/app/network/exceptions/api_exceptions/api_exception.dart';

class NotFoundException extends ApiException{
  NotFoundException(String message, String status)
      : super(httpCode: HttpStatus.notFound, status: status,message: message);
}