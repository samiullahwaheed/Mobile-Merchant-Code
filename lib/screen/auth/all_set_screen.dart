import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import 'package:merchent/utils/app_size.dart';
import '../../constant/app_image_path.dart';
import '../../routes/app_routes.dart';
import '../../widget/auth_top_round_widget.dart';

class AllSetThanksScreen extends StatelessWidget {
  const AllSetThanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF3FAE6A), // Green background
        statusBarIconBrightness: Brightness.light, // White icons on Android
        statusBarBrightness: Brightness.dark, // White icons on iOS
      ),
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                const TopRoundWidget(),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(AppImagePath.subscriptionThanks),
                ),
              ],
            ),
            SizedBox(height: AppSize.height(value: 30)),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  SizedBox(height: AppSize.height(value: 30)),
                  const TextWidget(
                    text: "You're All Set!",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: AppSize.height(value: 30)),
                  const TextWidget(
                    text: "Your sign-up has been successful.",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    textAlignment: TextAlign.start,
                  ),
                  SizedBox(height: AppSize.height(value: 30)),
                  buildContainerMethod(
                    text: "Go to Homepage ➔",
                    function: () => Get.toNamed(AppRoutes.signInScreen),
                  ),
                  SizedBox(height: AppSize.height(value: 30)),
                  const TextWidget(
                    text: "Your sign-up has been successful.",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: AppSize.height(value: 30)),
                  const TextWidget(
                    text:
                        "Subscribe now to unlock the best rewards and exclusive benefits. Don’t miss out on the full experience!.",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textAlignment: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
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
