import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/notification_screen/model/notification_model.dart';
import 'package:merchent/service/repository/notification_repository.dart';
import '../../../service/sockets/app_socket_all_operation.dart';
import '../../../utils/app_log/app_log.dart';
import '../../../utils/app_log/error_log.dart';
import 'package:merchent/widget/app_snack_bar/app_snack_bar.dart';

class NotificationController extends GetxController {
  final NotificationRepository _repository = NotificationRepository();
  AppSocketAllOperation appSocketAllOperation = AppSocketAllOperation.instance;

  var isLoading = false.obs;
  var notificationsList = <Notifications>[].obs;
  var unreadCount = 0.obs;

  var page = 1;
  var limit = 10;
  var hasNextPage = true.obs;
  var isLoadMoreRunning = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    requestPermission();
    getFCMToken();
    listenFCM();
    onAppInitialDataLoad();
  }

  void notificationSocketHandler(dynamic data) {
    try {
      final newNotification = Notifications.fromJson(data);

      final hasId = (newNotification.sId?.isNotEmpty ?? false);
      final hasBody = (newNotification.body?.isNotEmpty ?? false);

      if (!hasId || !hasBody) return;

      notificationsList.insert(0, newNotification);
      unreadCount.value++; // Increment unread count
      notificationsList.refresh();
    } catch (e) {
      errorLog("notificationSocketHandler $e");
    }
  }

  Future<void> onAppInitialDataLoad() async {
    try {
      isLoading.value = true;
      // await onDataLoad();
      // paginationData();

      appSocketAllOperation.readEvent(
        event: "newNotification",
        handler: (data) {
          notificationSocketHandler(data);

          appLog('👌👌👌👌new notification==>>> ${data}  ');
        },
      );
    } catch (e) {
      errorLog(e);
    }
    isLoading.value = false;
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      page = 1;
      hasNextPage.value = true;
      isLoadMoreRunning.value = false;

      final response = await _repository.getNotifications(
        queryParams: {'page': page, 'limit': limit},
      );

      if (response != null && response.data != null) {
        notificationsList.value = response.data!.notifications ?? [];
        unreadCount.value = response.data!.unreadCount ?? 0;

        // Update pagination status
        final totalPages = response.pagination?.totalPage ?? 1;
        if (page >= totalPages) {
          hasNextPage.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreNotifications() async {
    if (hasNextPage.value == true &&
        isLoading.value == false &&
        isLoadMoreRunning.value == false) {
      try {
        isLoadMoreRunning.value = true;
        page += 1;

        final response = await _repository.getNotifications(
          queryParams: {'page': page, 'limit': limit},
        );

        if (response != null && response.data != null) {
          final newNotifications = response.data!.notifications ?? [];
          if (newNotifications.isNotEmpty) {
            notificationsList.addAll(newNotifications);
          }

          final totalPages = response.pagination?.totalPage ?? 1;
          if (page >= totalPages) {
            hasNextPage.value = false;
          }
        } else {
          hasNextPage.value = false;
        }
      } catch (e) {
        errorLog('Error loading more notifications: $e');
      } finally {
        isLoadMoreRunning.value = false;
      }
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final message = await _repository.readAllNotifications();
      if (message != null) {
        // Update local state
        for (var notification in notificationsList) {
          notification.isRead = true;
        }
        notificationsList.refresh();
        unreadCount.value = 0;

        AppSnackBar.success(message);
      }
    } catch (e) {
      errorLog('markAllAsRead error: $e');
    }
  }

  Future<void> getFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      appLog("FCM TOKEN: $token");
    } catch (e) {
      errorLog("Failed to get FCM token: $e");
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      appLog('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      appLog('User granted provisional permission');
    } else {
      appLog('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      appLog("Got a message whilst in the foreground!");
      appLog("Message data: ${message.data}");

      if (notification != null && android != null) {
        AppSnackBar.notification(
          title: notification.title ?? 'Notification',
          body: notification.body ?? '',
        );
      }
    });
  }
}
