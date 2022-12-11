
import 'package:flutter_infinite_list/app/network/exceptions/base_exceptions/base_exception.dart';

class TimeoutException extends BaseException{
  TimeoutException(String messsage) : super(message: messsage);
}