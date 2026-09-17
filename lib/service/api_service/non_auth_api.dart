import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/service/api_service/cookie_service.dart';

class NonAuthApi {
  final Dio _dio = Dio();

  NonAuthApi() {
    _dio.options.baseUrl = AppApiEndPoint.instance.baseUrl;
    _dio.options.sendTimeout = const Duration(seconds: 120);
    _dio.options.connectTimeout = const Duration(seconds: 120);
    _dio.options.receiveTimeout = const Duration(seconds: 120);
    _dio.options.followRedirects = false;

    _dio.interceptors.add(CookieManager(CookieService.instance.cookieJar));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.baseUrl = AppApiEndPoint.instance.baseUrl;
          options.contentType = 'application/json';
          options.headers['Accept'] = 'application/json';
          handler.next(options);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            // ignore: avoid_print
            print('NonAuthApi error: ${error.response?.statusCode} ${error.requestOptions.uri}');
          }
          handler.next(error);
        },
      ),
    );
  }

  Dio get sendRequest => _dio;
}
