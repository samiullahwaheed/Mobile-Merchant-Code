import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import 'package:merchent/utils/app_size.dart';
import 'package:merchent/widget/button_widget/button_widget.dart';
import '../../constant/app_image_path.dart';
import '../../routes/app_routes.dart';
import '../../widget/auth_top_round_widget.dart';

class SubscriptionThanksScreen extends StatelessWidget {
  const SubscriptionThanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF3FAE6A), // Green background
        statusBarIconBrightness: Brightness.light, // White icons on Android
        statusBarBrightness: Brightness.dark, // White icons on iOS
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopRoundWidget(
                hasAppBar: true,
                child: Center(
                  child: Image.asset(AppImagePath.subscriptionThanks),
                ),
              ),
              SizedBox(height: AppSize.height(value: 30)),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    SizedBox(height: AppSize.height(value: 30)),
                    const TextWidget(
                      text: 'Thank you for purchasing the Gold Subscription!',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: AppSize.height(value: 30)),
                    const TextWidget(
                      text:
                          "You're all set to enjoy premium features and exclusive benefits. Let’s get started! If you need any help, we're here for you.",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textAlignment: TextAlign.start,
                    ),
                    SizedBox(height: AppSize.height(value: 30)),
                    ButtonWidget(
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.signInScreen);
                      },
                      backgroundColor: const Color(0xFF3FAE6A),
                      label: 'Go to Homepage ➔',
                      buttonRadius: BorderRadius.circular(100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainerMethod({
    Color? backgroundColor,
    required String text,
    Color? textColor,
    required VoidCallback function,
  }) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: double.infinity,
        height: 54,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: ShapeDecoration(
          color: backgroundColor ?? const Color(0xFF3FAE6A), // Button color
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFF198248), // Stroke color
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: TextWidget(
          text: text,
          fontColor: textColor ?? Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
