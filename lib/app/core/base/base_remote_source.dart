import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_infinite_list/app/network/exceptions/base_exceptions/base_exception.dart';
import '/app/network/dio_provider.dart';
import '/app/network/error_handlers.dart';
import '/flavors/build_config.dart';

abstract class BaseRemoteSource {
  Dio get dioBasicClient => DioProvider.dioBasicInstance;

  Future<Dio> get dioClientWithToken async => await DioProvider.dioInstanceWithToken;
  Future<Dio> get dioClientForImage async => await DioProvider.dioInstanceWithTokenForImage;

  final logger = BuildConfig.instance.config.logger;

  Future<Response<T>> callApiWithErrorParser<T>(Future<Response<T>> api) async {
    try {
      Response<T> response = await api;

      if (response.statusCode != HttpStatus.ok ||
          (response.data as Map<String, dynamic>)['statusCode'] !=
              HttpStatus.ok) {
        logger.v("HttpStatus Ok : API call is successfully done.");
      }

      return response;
    } on DioError catch (dioError) {
      Exception exception = handleDioError(dioError);
      logger.e(
          "Throwing error from repository: >>>>>>> $exception : ${(exception as BaseException).message}");
      throw exception;
    } catch (error) {
      logger.e("Generic error: >>>>>>> $error");

      if (error is BaseException) {
        rethrow;
      }

      throw handleError("$error");
    }
  }
}
