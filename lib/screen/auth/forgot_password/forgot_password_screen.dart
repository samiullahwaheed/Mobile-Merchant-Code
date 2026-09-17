import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchent/constant/app_image_path.dart';

import 'package:merchent/screen/common_widget/common_button_widget.dart';
import 'package:merchent/utils/app_size.dart';
import 'package:merchent/widget/text_field_widget/email_and_phone_field.dart';
import '../../../widget/auth_top_round_widget.dart';
import '../../../widget/text_field_widget/text_field_widget.dart';
import '../../common_widget/common_text_widget.dart';
import 'controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordOnTapButtonController controller = Get.put(
    ForgotPasswordOnTapButtonController(),
  );

  ForgotPasswordScreen({super.key});

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
                child: Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(AppImagePath.forgotPasswordImage),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const TextWidget(
                      text: "Forgot Your Password?",
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                    const TextWidget(
                      text:
                          "No worries! Enter your phone number below and we'll send you a OTP to reset your password.",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: AppSize.height(value: 20)),
                    buildForm(controller: controller),
                    SizedBox(height: AppSize.height(value: 30)),
                    Obx(() {
                      return controller.isLoading.value == true
                          ? const Center(child: CircularProgressIndicator())
                          : CommonElevatedButton(
                              text: 'Get Verification Code',
                              width: double.infinity,
                              onPressed: () =>
                                  controller.onTapSentPhoneOtpButton(),
                              backgroundColor: const Color(0xFF3FAE6A),
                              borderRadius: 100,
                            );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Text Field
  Widget buildForm({required ForgotPasswordOnTapButtonController controller}) {
    return Form(
      child: Column(
        children: [
          EmailAndPhoneField(
            controller: controller.phoneNumberController,
            defaultType: InputFieldType.email,
            showTypeSelector: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            allowedCountryCodes: ["PK"],
            defaultCountryCode: "PK",
            fillColor: Colors.grey[100],
            borderRadius: 10,
            isOptional: false,
            validator: controller.validateNumber,
          ),
        
        ],
      ),
    );
  }
}
