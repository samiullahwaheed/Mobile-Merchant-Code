import 'package:dio/dio.dart';
import 'package:merchent/service/api_service/api_services.dart';
import 'package:merchent/service/api_service/non_auth_api.dart';
import 'package:merchent/service/api_service/service_model/service_model.dart';

class NonAuthApiService {
  static final NonAuthApi _nonAuthApi = NonAuthApi();

  static Future<ApiResponseModel> postApi(
    String url,
    dynamic body, {
    Map<String, String>? header,
  }) async {
    try {
      final response = await _nonAuthApi.sendRequest.post(
        url,
        data: body,
        options: Options(headers: header),
      );
      return ApiService.handleResponse(response);
    } catch (e) {
      return ApiService.handleError(e);
    }
  }

  static Future<ApiResponseModel> getApi(
    String url, {
    Map<String, String>? header,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _nonAuthApi.sendRequest.get(
        url,
        options: Options(headers: header),
        queryParameters: queryParams,
      );
      return ApiService.handleResponse(response);
    } catch (e) {
      return ApiService.handleError(e);
    }
  }

  static Future<ApiResponseModel> patchApi(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) async {
    try {
      final response = await _nonAuthApi.sendRequest.patch(
        url,
        data: body,
        options: Options(headers: header),
      );
      return ApiService.handleResponse(response);
    } catch (e) {
      return ApiService.handleError(e);
    }
  }
}
