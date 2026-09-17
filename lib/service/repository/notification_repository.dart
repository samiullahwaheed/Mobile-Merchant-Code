import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/screen/notification_screen/model/notification_model.dart';
import 'package:merchent/service/api_service/api_services.dart';
import 'package:merchent/utils/app_log/app_log.dart';

class NotificationRepository {
  Future<NotificationModel?> getNotifications({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.notificationsEndPoint,
        queryParams: queryParams,
      );

      appLog('Notification API Response - Status: ${response.statusCode}');
      appLog('Notification API Response - Message: ${response.message}');
      appLog('Notification API Response - Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        if (responseBody is Map<String, dynamic>) {
          return NotificationModel.fromJson(responseBody);
        }
      }
      return null;
    } catch (e) {
      appLog('Notification API Error: $e');
      return null;
    }
  }

  Future<String?> readAllNotifications() async {
    try {
      final response = await ApiService.patchApi(
        AppApiEndPoint.instance.notificationsReadEndPoint,
        body: {},
      );

      appLog(
        'Read All Notifications API Response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.message;
      }
      return null;
    } catch (e) {
      appLog('Read All Notifications API Error: $e');
      return null;
    }
  }
}
