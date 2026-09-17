import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/service/api_service/cookie_service.dart';
import 'package:merchent/service/api_service/service_model/service_model.dart';
import 'package:merchent/service/repository/auth_repository/refresh_token_repository.dart';
import 'package:merchent/service/storage/storage_service.dart';
import '../../utils/app_translation/app_static_key.dart';

final Logger logger = Logger();

class ApiService {
  static final _AppApiClient _client = _AppApiClient();
  static Dio get _dio => _client.dio;

  static late Response bodyData;

  static Future<ApiResponseModel> postApi(
    String url,
    body, {
    Map<String, String>? header,
  }) async {
    return requestApi(url, 'POST', body: body, header: header);
  }

  static Future<ApiResponseModel> getApi(
    String url, {
    Map<String, String>? header,
    Map<String, dynamic>? queryParams,
  }) async {
    return requestApi(url, 'GET', header: header, queryParams: queryParams);
  }

  static Future<ApiResponseModel> putApi(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? header,
  }) async {
    return requestApi(url, 'PUT', body: body, header: header);
  }

  static Future<ApiResponseModel> patchApi(
    String url, {
    body,
    Map<String, String>? header,
  }) async {
    return requestApi(url, 'PATCH', body: body, header: header);
  }

  static Future<ApiResponseModel> deleteApi({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? header,
  }) async {
    return requestApi(url, 'DELETE', body: body, header: header);
  }

  static Future<ApiResponseModel> postMultipartApi(
    String url,
    dynamic body, {
    List<MultipartBody>? multipartBody,
    Map<String, String>? header,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {};

      if (body is Map) {
        body.forEach((key, value) {
          if (value is List) {
            for (int i = 0; i < value.length; i++) {
              formDataMap['$key[$i]'] = value[i].toString();
            }
          } else if (value != null) {
            formDataMap[key.toString()] = value.toString();
          }
        });
      }

      final formData = FormData.fromMap(formDataMap);

      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          var mimeType =
              lookupMimeType(element.file.path) ?? 'application/octet-stream';

          if (kDebugMode) {
            logger.i('File path: ${element.file.path}');
            logger.i('MimeType: $mimeType');
          }

          var multipartFile = await MultipartFile.fromFile(
            element.file.path,
            filename: element.file.path.split('/').last,
            contentType: MediaType.parse(mimeType),
          );

          formData.files.add(MapEntry(element.key, multipartFile));
        }
      }

      final headers = header ?? {};
      headers['Content-Type'] = 'multipart/form-data';

      Response response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
      );

      return await handleResponse(response);
    } catch (e) {
      return await handleError(e);
    }
  }

  static Future<ApiResponseModel> patchMultipartApi(
    String url,
    Map<String, dynamic> body, {
    List<MultipartBody>? multipartBody,
    Map<String, String>? header,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData();

      body.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          var mimeType =
              lookupMimeType(element.file.path) ?? 'application/octet-stream';

          if (kDebugMode) {
            logger.i('File path: ${element.file.path}');
            logger.i('MimeType: $mimeType');
          }

          var multipartFile = await MultipartFile.fromFile(
            element.file.path,
            filename: element.file.path.split('/').last,
            contentType: MediaType.parse(mimeType),
          );

          formData.files.add(MapEntry(element.key, multipartFile));
        }
      }

      if (kDebugMode) {
        logger.i('========== FormData Fields ==========');
        for (var entry in formData.fields) {
          logger.i('${entry.key}: ${entry.value}');
        }

        logger.i('========== FormData Files ==========');
        for (var entry in formData.files) {
          logger.i('Key: ${entry.key}');
          logger.i('Filename: ${entry.value.filename}');
          logger.i('ContentType: ${entry.value.contentType}');
          logger.i('Length: ${entry.value.length}');
        }
      }

      final headers = header ?? {};
      headers['Content-Type'] = 'multipart/form-data';

      Response response = await _dio.patch(
        url,
        data: formData,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
      );

      return await handleResponse(response);
    } catch (e) {
      return await handleError(e);
    }
  }

  static Future<ApiResponseModel> requestApi(
    String url,
    String method, {
    dynamic body,
    Map<String, String>? header,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response = await _dio.request(
        url,
        data: body,
        options: Options(method: method, headers: header),
        queryParameters: queryParams,
      );

      return await handleResponse(response);
    } catch (e) {
      return await handleError(e);
    }
  }

  static Future<ApiResponseModel> handleResponse(Response response) async {
    if (response.statusCode == 201) {
      return ApiResponseModel(
        200,
        response.data['message'] ?? '',
        response.data,
      );
    }

    return ApiResponseModel(
      response.statusCode ?? 500,
      response.data['message'] ?? '',
      response.data,
    );
  }

  static Future<ApiResponseModel> handleError(dynamic error) async {
    if (error is DioException) {
      if (error.response != null) {
        if (error.response?.statusCode == 502) {
          return ApiResponseModel(502, 'bad Gateway', {});
        }

        if (error.response?.statusCode == 401) {
          return ApiResponseModel(
            401,
            error.response?.data?['message'] ?? 'Unauthorized',
            error.response?.data is Map ? error.response?.data : {},
          );
        }
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return ApiResponseModel(408, AppStaticKey.requestTimeOut, {});
        case DioExceptionType.connectionError:
          return ApiResponseModel(503, AppStaticKey.noInternetConnection, {});
        default:
          return ApiResponseModel(
            error.response?.statusCode ?? 500,
            error.response?.data?['message'] ??
                error.message ??
                'Unknown Error',
            {},
          );
      }
    } else if (error is SocketException) {
      return ApiResponseModel(503, AppStaticKey.noInternetConnection, {});
    } else if (error is FormatException) {
      return ApiResponseModel(
        400,
        AppStaticKey.badResponseRequest,
        bodyData.data,
      );
    } else if (error is TimeoutException) {
      return ApiResponseModel(408, AppStaticKey.requestTimeOut, {});
    } else {
      return ApiResponseModel(400, error.toString(), {});
    }
  }
}

class _AppApiClient {
  final Dio dio = Dio();
  final Stopwatch _stopwatch = Stopwatch();

  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  _AppApiClient() {
    dio.options.baseUrl = AppApiEndPoint.instance.baseUrl;
    dio.options.sendTimeout = const Duration(seconds: 120);
    dio.options.connectTimeout = const Duration(seconds: 120);
    dio.options.receiveTimeout = const Duration(seconds: 120);
    dio.options.followRedirects = false;

    dio.interceptors.add(CookieManager(CookieService.instance.cookieJar));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.baseUrl = AppApiEndPoint.instance.baseUrl;
          options.contentType = 'application/json';
          options.headers['Accept'] = 'application/json';

          final token = LocalStorage.getToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          options
            ..sendTimeout = const Duration(seconds: 120)
            ..receiveTimeout = const Duration(seconds: 120)
            ..connectTimeout = const Duration(seconds: 120)
            ..extra['stopwatch'] = _stopwatch;

          _stopwatch.start();

          if (kDebugMode) {
            logger.i('REQUEST → ${options.method} ${options.uri}');
            logger.i('HEADERS → ${options.headers}');

            if (options.data != null) {
              const encoder = JsonEncoder.withIndent('  ');
              try {
                logger.i('BODY → \n${encoder.convert(options.data)}');
              } catch (_) {
                logger.i('BODY → ${options.data}');
              }
            }
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          _stopwatch.stop();

          if (kDebugMode) {
            logger.i(
              'RESPONSE ← ${response.statusCode} (${_stopwatch.elapsedMilliseconds} ms)',
            );

            if (response.data != null) {
              const encoder = JsonEncoder.withIndent('  ');
              try {
                logger.i('DATA ↓\n${encoder.convert(response.data)}');
              } catch (_) {
                logger.i('DATA ↓ ${response.data}');
              }
            }
          }

          _stopwatch.reset();
          handler.next(response);
        },
        onError: (error, handler) async {
          _stopwatch.stop();

          if (kDebugMode) {
            logger.e(
              'ERROR ← ${error.response?.statusCode} ${error.requestOptions.uri}',
            );

            if (error.response?.data != null) {
              const encoder = JsonEncoder.withIndent('  ');
              try {
                logger.e(
                  'ERROR DATA ↓\n${encoder.convert(error.response?.data)}',
                );
              } catch (_) {
                logger.e('ERROR DATA ↓ ${error.response?.data}');
              }
            }
          }

          _stopwatch.reset();

          if (error.response?.statusCode == 401) {
            final message = error.response?.data?['message'];
            logger.i('401 message: $message');

            if (error.requestOptions.extra['_retriedAfterRefresh'] == true) {
              logger.i('Request already retried after refresh — logging out.');
              await _logout();
              return handler.next(error);
            }

            final authHeader = error.requestOptions.headers['Authorization']
                ?.toString();
            final expiredToken =
                authHeader != null && authHeader.startsWith('Bearer ')
                ? authHeader.substring(7)
                : LocalStorage.getToken();

            logger.i('401 — calling resetToken before logout...');
            final newToken = await _refreshAccessToken(
              expiredAccessToken: expiredToken,
            );

            if (newToken != null) {
              try {
                final requestOptions = error.requestOptions;
                requestOptions.headers['Authorization'] = 'Bearer $newToken';
                requestOptions.extra['_retriedAfterRefresh'] = true;

                logger.i('Retrying failed request with new token...');
                final response = await dio.fetch(requestOptions);
                return handler.resolve(response);
              } catch (e) {
                logger.e('retry after token refresh: $e');
                if (e is DioException && e.response?.statusCode == 401) {
                  await _logout();
                  return handler.next(e);
                }
                return handler.next(error);
              }
            }

            logger.i('resetToken failed — logging out.');
            await _logout();
            return handler.next(error);
          }

          handler.next(error);
        },
      ),
    );
  }

  Future<String?> _refreshAccessToken({String? expiredAccessToken}) async {
    if (_isRefreshing) {
      return _refreshCompleter?.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final newToken = await RefreshTokenRepository.instance.resetToken(
        expiredAccessToken: expiredAccessToken,
      );
      _refreshCompleter?.complete(newToken);
      return newToken;
    } catch (e) {
      logger.e('refreshAccessToken: $e');
      _refreshCompleter?.complete(null);
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _logout() async {
    await LocalStorage.removeAllPrefData();
  }
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

class MultipartListBody {
  String key;
  String value;

  MultipartListBody(this.key, this.value);
}
