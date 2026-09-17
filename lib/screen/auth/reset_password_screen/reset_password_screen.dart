import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/auth/reset_password_screen/controller/reset_password_onTap_button_controller.dart';
import 'package:merchent/screen/common_widget/common_button_widget.dart';
import 'package:merchent/utils/app_size.dart';
import '../../../constant/app_image_path.dart';
import '../../../widget/auth_top_round_widget.dart';
import '../../../widget/text_field_widget/text_field_widget.dart';
import '../../common_widget/common_text_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  ResetPasswordScreen({super.key});

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
              Stack(
                children: [
                  const TopRoundWidget(),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(AppImagePath.resetPasswordImage),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const TextWidget(
                text: 'Set Your New Password',
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 8),
              const TextWidget(
                text:
                    'Choose a strong, unique password to secure your account.',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    buildForm(),
                    SizedBox(height: AppSize.height(value: 40)),
                    CommonElevatedButton(
                      text: 'Reset Password',
                      width: double.infinity,
                      onPressed: () {
                        controller.onTapResetButton();
                      },
                      backgroundColor: const Color(0xFF3FAE6A),
                      borderRadius: 100,
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

  Widget buildForm() {
    return Form(
      child: Column(
        children: [
          TextFieldWidget(
            validator: controller.validateNewPassword,
            controller: controller.newPasswordController,
            hintText: 'Password',
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            suffixIcon: true,
          ),
          SizedBox(height: AppSize.height(value: 20)),
          TextFieldWidget(
            validator: controller.validateConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            controller: controller.confirmPasswordController,
            hintText: 'Confirm Password',
            maxLines: 1,
            suffixIcon: true,
          ),
        ],
      ),
    );
  }
}
