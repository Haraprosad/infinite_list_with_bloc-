import 'package:flutter_infinite_list/app/network/exceptions/base_exceptions/base_exception.dart';

class JsonFormatException extends BaseException{
  JsonFormatException(String message):super(message: message);
}