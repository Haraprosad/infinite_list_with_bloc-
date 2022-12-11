
import 'dart:io';

import 'package:flutter_infinite_list/app/network/exceptions/base_api_exceptions/base_api_exception.dart';

class ServiceUnavailableException extends BaseApiException{
  ServiceUnavailableException(String message)
      :super(httpCode: HttpStatus.serviceUnavailable,message: message,status: "service_unavailable");
}