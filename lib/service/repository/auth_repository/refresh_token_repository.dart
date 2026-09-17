import 'package:dio/dio.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/service/api_service/non_auth_api.dart';
import 'package:merchent/service/storage/storage_key.dart';
import 'package:merchent/service/storage/storage_service.dart';
import 'package:merchent/utils/app_log/app_log.dart';

class RefreshTokenRepository {
  RefreshTokenRepository._();

  static final RefreshTokenRepository instance = RefreshTokenRepository._();

  final NonAuthApi _nonAuthApi = NonAuthApi();

  Future<void> saveAuthTokens(Map<String, dynamic> data) async {
    final accessToken = data['accessToken']?.toString() ?? '';
    if (accessToken.isNotEmpty) {
      LocalStorage.token = accessToken;
      await LocalStorage.setString(LocalStorageKeys.token, accessToken);
    }

    final refreshToken =
        data['refreshToken']?.toString() ?? data['refresh_token']?.toString();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      LocalStorage.refreshToken = refreshToken;
      await LocalStorage.setString(LocalStorageKeys.refreshToken, refreshToken);
    }
  }

  String? extractAccessToken(dynamic responseData) {
    if (responseData is! Map) return null;

    final data = responseData['data'] ?? responseData;
    if (data is! Map) return null;

    final token = data['accessToken'] ?? data['token'] ?? data['access_token'];
    return token?.toString();
  }

  Future<String?> resetToken({String? expiredAccessToken}) async {
    try {
      final storedRefreshToken = LocalStorage.getRefreshToken();
      final accessToken = expiredAccessToken ?? LocalStorage.getToken();

      final headers = <String, dynamic>{'Accept': 'application/json'};
      if (accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      final body = storedRefreshToken.isNotEmpty
          ? {'refreshToken': storedRefreshToken, 'device': 'merchant'}
          : null;

      appLog('resetToken: calling ${AppApiEndPoint.instance.resetToken}');

      final response = await _nonAuthApi.sendRequest.post(
        AppApiEndPoint.instance.resetToken,
        data: body,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final newAccessToken = extractAccessToken(response.data);

        if (newAccessToken == null || newAccessToken.isEmpty) {
          appLog('resetToken: accessToken missing in response');
          return null;
        }

        LocalStorage.token = newAccessToken;
        await LocalStorage.setString(LocalStorageKeys.token, newAccessToken);

        final data = response.data is Map ? response.data['data'] : null;
        if (data is Map<String, dynamic>) {
          await saveAuthTokens(data);
        }

        appLog('Token Refreshed', source: 'resetToken');
        return newAccessToken;
      }

      appLog(
        'resetToken: unexpected response ${response.statusCode}',
        source: 'resetToken',
      );
      return null;
    } on DioException catch (e) {
      appLog(
        'resetToken failed: ${e.response?.statusCode} ${e.response?.data}',
        source: 'resetToken',
      );
      return null;
    } catch (e) {
      appLog('resetToken error: $e', source: 'resetToken');
      return null;
    }
  }
}
