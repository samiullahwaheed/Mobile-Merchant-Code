import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/notification_screen/controller/notification_controller.dart';
import 'package:merchent/widget/appbar_widget/appbar_widget.dart';
import '../../constant/app_color/app_theme_color.dart';
import '../../utils/app_size.dart';
import '../../widget/app_text/app_text.dart';
import '../common_widget/common_text_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = Get.put(NotificationController());

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchNotifications();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.loadMoreNotifications();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: appThemeColor.button1,
        textWidget: TextWidget(
          text: 'Notification',
          fontWeight: FontWeight.w700,
          fontSize: 18,
          fontColor: appThemeColor.text2,
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new, color: appThemeColor.text2),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              controller.markAllAsRead();
            },
            child: AppText(
              data: 'Read All',
              color: appThemeColor.text2,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notificationsList.isEmpty) {
          return Center(
            child: AppText(
              data: 'No Notifications Found',
              color: appThemeColor.text2,
              fontSize: 16,
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: controller.notificationsList.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.notificationsList.length) {
              return Obx(() {
                return controller.isLoadMoreRunning.value
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink();
              });
            }
            final notification = controller.notificationsList[index];
            return NotificationCard(
              appThemeColor: appThemeColor,
              title: notification.title,
              message: notification.body,
              time: notification.timeAgo,
              isRead: notification.isRead ?? false,
            );
          },
        );
      }),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String? title;
  final String? message;
  final String? time;
  final bool isRead;
  final AppThemeColor appThemeColor;

  const NotificationCard({
    super.key,
    required this.appThemeColor,
    this.title,
    this.message,
    this.time,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width(value: 16),
        vertical: AppSize.width(value: 4),
      ),
      child: Container(
        padding: EdgeInsets.all(AppSize.width(value: 16)),
        decoration: BoxDecoration(
          color: isRead ? Colors.transparent : Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead ? appThemeColor.icon : Colors.green,
            width: 0.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSize.width(value: 30),
              height: AppSize.width(value: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isRead
                    ? appThemeColor.cart
                    : Colors.green.withOpacity(0.2),
              ),
              child: Icon(
                Icons.notification_add,
                color: isRead ? appThemeColor.icon : Colors.green,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data: title ?? "No Data",
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w600,
                    color: appThemeColor.text2,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    data: message ?? "No Data",
                    fontSize: AppSize.width(value: 12),
                    fontWeight: FontWeight.w400,
                    color: appThemeColor.text2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AppText(
              data: time ?? "just now",
              fontSize: AppSize.width(value: 12),
              fontWeight: FontWeight.w500,
              color: appThemeColor.text2,
            ),
          ],
        ),
      ),
    );
  }
}
