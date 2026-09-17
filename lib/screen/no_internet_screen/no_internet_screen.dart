import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/constant/app_color/app_theme_color.dart';
import 'package:merchent/screen/no_internet_screen/controller/no_internet_controller.dart';
import 'package:merchent/utils/app_translation/app_static_key.dart';
import 'package:merchent/widget/app_button/app_button.dart';
import 'package:merchent/widget/app_text/app_text.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor color = Theme.of(context).extension<AppThemeColor>()!;
    final controller = Get.put(NoInternetController());

    return Scaffold(
      backgroundColor: color.surfacePrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 80,
                color: color.icon,
              ),
              const SizedBox(height: 24),
              AppText(
                data: AppStaticKey.noInternetConnection,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color.text,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              AppText(
                data:
                    'Your internet connection appears to be offline. Please check your network and try again.',
                fontSize: 14,
                color: color.text2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Obx(
                () => AppButton(
                  title: 'Try Again',
                  isLoading: controller.isChecking.value,
                  titleColor: color.cart1,
                  onTap: controller.tryAgain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
