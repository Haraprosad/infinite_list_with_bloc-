import 'package:flutter_infinite_list/app/network/exceptions/base_exceptions/base_exception.dart';

class AppException extends BaseException{
  AppException({String message = ""}):super(message: message);
}