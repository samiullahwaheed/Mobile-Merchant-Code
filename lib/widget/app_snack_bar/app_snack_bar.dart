import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../screen/common_widget/common_text_widget.dart';
import '../../utils/app_size.dart';
import '../space_widget/space_widget.dart';

class AppSnackBar {
  static error(String parameterValue, {int seconds = 2}) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.grey,
        animationDuration: const Duration(seconds: 2),
        duration: Duration(seconds: seconds),
        isDismissible: true,
        onTap: (snack) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.closeAllSnackbars();
          });
        },
        messageText: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(
              text: "Error!",
              fontColor: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
            const SpaceWidget(spaceHeight: 5),
            TextWidget(
              text: parameterValue,
              fontColor: Colors.white,
              textAlignment: TextAlign.center,
            ),
          ],
        ),
        borderRadius: ResponsiveUtils.width(20),
        padding: EdgeInsets.all(ResponsiveUtils.width(10)),
        margin: EdgeInsets.symmetric(
          horizontal: AppSize.width(value: 40.0),
          vertical: AppSize.width(value: 30),
        ),
      ),
    );
  }

  static success(String parameterValue, {int seconds = 2}) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.grey,
        animationDuration: const Duration(seconds: 2),
        duration: Duration(seconds: seconds),
        isDismissible: true,
        onTap: (snack) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.closeAllSnackbars();
          });
        },
        messageText: TextWidget(
          text: parameterValue,
          fontColor: Colors.white,
          textAlignment: TextAlign.center,
        ),
        borderRadius: AppSize.width(value: 20.0),
        padding: EdgeInsets.all(AppSize.width(value: 10.0)),
        margin: EdgeInsets.symmetric(
          horizontal: AppSize.width(value: 40.0),
          vertical: AppSize.width(value: 30),
        ),
      ),
    );
  }

  static message(
    String parameterValue, {
    Color backgroundColor = Colors.grey,
    Color color = Colors.white,
    int seconds = 2,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: backgroundColor,
        animationDuration: const Duration(seconds: 2),
        duration: Duration(seconds: seconds),
        isDismissible: true,
        onTap: (snack) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.closeAllSnackbars();
          });
        },
        messageText: TextWidget(
          text: parameterValue,
          fontColor: color,
          fontSize: 16,
          textAlignment: TextAlign.center,
          fontWeight: FontWeight.w400,
        ),
        borderRadius: AppSize.width(value: 20.0),
        padding: EdgeInsets.all(AppSize.width(value: 10.0)),
        margin: EdgeInsets.symmetric(
          horizontal: AppSize.width(value: 40.0),
          vertical: AppSize.width(value: 30),
        ),
      ),
    );
  }

  static notification({required String title, required String body}) {
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.notifications_active, color: Colors.blue),
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
