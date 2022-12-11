import 'package:dio/dio.dart';
import 'package:flutter_infinite_list/app/network/request_header_interceptor.dart';
import 'package:flutter_infinite_list/core/app_values.dart';
import 'package:flutter_infinite_list/core/shared_pref.dart';
import 'package:flutter_infinite_list/core/string_constants.dart';
import 'package:flutter_infinite_list/flavors/build_config.dart';
import 'package:flutter_infinite_list/flavors/environment.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioProvider {
  static final String baseUrl = BuildConfig.instance.config.baseUrl;

  static Dio? _instance;

  static const int _maxLineWidth = AppValues.dioLoggerMaxLength;

  static final _prettyDioLogger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: BuildConfig.instance.environment == Environment.DEVELOPMENT,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: _maxLineWidth);

  static final BaseOptions _options = BaseOptions(
    //baseUrl: baseUrl,
    connectTimeout: 60 * 1000,
    receiveTimeout: 60 * 1000,
  );

  static Dio get httpDio {
    if (_instance == null) {
      _instance = Dio(_options);

      _instance!.interceptors.add(_prettyDioLogger);

      return _instance!;
    } else {
      _instance!.interceptors.clear();
      _instance!.interceptors.add(_prettyDioLogger);

      return _instance!;
    }
  }

  ///returns a Dio client
  static Dio get dioBasicInstance {
    _addInterceptors();

    return _instance!;
  }

  ///returns a Dio client with Access token in header
  static Future<Dio> get dioInstanceWithToken async{
    _addInterceptors();
    _instance!.options.headers = await getCustomHeadersWithToken();

    return _instance!;
  }

  static Future<Dio> get dioInstanceWithTokenForImage async{
    _addInterceptors();
    _instance!.options.headers = await getCustomHeadersForImage();

    return _instance!;
  }

  static _addInterceptors() {
    _instance ??= httpDio;
    _instance!.interceptors.clear();
    _instance!.interceptors.add(RequestHeaderInterceptor());
    _instance!.interceptors.add(_prettyDioLogger);
  }

  static Future<Map<String, String>> getCustomHeadersWithToken() async {
    final String? accessToken =
    await SharedPref.getString(StringConstants.keyToken);
    var customHeaders = {'content-type': 'application/json'};
    if(accessToken!=null){
    if (accessToken.trim().isNotEmpty) {
      customHeaders.addAll({
        'Authorization': "Bearer $accessToken",
      });
    }
    }

    return customHeaders;
  }

  static Future<Map<String, String>> getCustomHeadersForImage() async {
    final String? accessToken =
    await SharedPref.getString(StringConstants.keyToken);
    var customHeaders = {'Content-type': 'application/json'};
    if(accessToken!=null){
    if (accessToken.trim().isNotEmpty) {
      customHeaders.addAll({
        "Accept": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Authorization": "Bearer $accessToken",
      });
    }
    }

    return customHeaders;
  }

}
