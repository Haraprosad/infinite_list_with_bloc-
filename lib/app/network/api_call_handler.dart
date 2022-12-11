import 'package:flutter/material.dart';
import 'package:flutter_infinite_list/app/network/exceptions/api_exceptions/api_exception.dart';
import 'package:flutter_infinite_list/app/network/exceptions/api_exceptions/not_found_exception.dart';
import 'package:flutter_infinite_list/app/network/exceptions/base_api_exceptions/service_unavailable_exception.dart';
import 'package:flutter_infinite_list/app/network/exceptions/base_api_exceptions/unauthorized_exception.dart';
import 'package:flutter_infinite_list/app/network/exceptions/base_exceptions/app_exception.dart';
import 'package:flutter_infinite_list/app/network/exceptions/base_exceptions/json_format_exception.dart';
import 'package:flutter_infinite_list/app/network/exceptions/base_exceptions/network_exception.dart';
import 'package:flutter_infinite_list/app/network/exceptions/base_exceptions/timeout_exception.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApiCallHandler{
 static dynamic callDataService<T>(
      Future<T> future,{
        Function(Exception exception)? onError,
        Function(T response)? onSuccess,
        Function? onStart,
        Function? onComplete,}
      ) async{

    Exception? _exception;

    /// When api call initiates, show loading
    // onStart == null? showLoading(): onStart();

    /// api call
    try{

      final T response = await future;

      if(onSuccess != null) onSuccess(response);

      //onComplete == null ? hideLoading() : onComplete();

      return response;

    } on ServiceUnavailableException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message);
    } on UnauthorizedException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message);
    } on TimeoutException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message);
    } on NetworkException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message);
    } on JsonFormatException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message);
    } on NotFoundException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message);
    } on ApiException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message);
    } on AppException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message);
    } catch (error) {
      _exception = AppException(message: "$error");
      showErrorMessage("$error");
      // logger.e("Controller>>>>>> error $error");
    }

    if (onError != null) onError(_exception);

    // onComplete == null ? hideLoading() : onComplete();

  }

  static showErrorMessage(String message){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
}