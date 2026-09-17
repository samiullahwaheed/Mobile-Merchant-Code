import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchent/constant/app_image_path.dart';
import 'package:merchent/utils/app_size.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../utils/app_log/app_log.dart';
import '../../../widget/auth_top_round_widget.dart';
import '../../../widget/button_widget/button_widget.dart';
import '../../../widget/space_widget/space_widget.dart';
import '../../../widget/text_button_widget/text_button_widget.dart';
import '../../common_widget/common_text_widget.dart';
import 'controller/verify_otp_screen_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  final VerifyOtpScreenController controller = Get.put(
    VerifyOtpScreenController(),
  );

  VerifyOtpScreen({super.key});

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
                  child: Image.asset(AppImagePath.createNewPassImage),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const TextWidget(
                      text: "Verification Code",
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                    const TextWidget(
                      text:
                          "Please enter the code sent to your Phone to continue.",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: AppSize.height(value: 30)),
                    TextWidget(
                      text: "We've Sent a Code to ${controller.phone}",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: AppSize.height(value: 20)),
                    _buildPinCodeTextField(context),

                    Obx(() {
                      return TextWidget(
                        text: controller.canResend.value
                            ? 'Remaining Time 00.00'
                            : "Send code again in ${controller.formatTime()}",
                        fontColor: controller.canResend.value
                            ? Colors.grey
                            : Colors.grey.shade500,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      );
                    }),
                    const SpaceWidget(spaceHeight: 12),
                    Obx(() {
                      if (controller.canResend.value) {
                        appLog("Resend Code Button is now visible!");
                      }
                      return controller.canResend.value
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const TextWidget(
                                    text: "Didn't receive code?'",
                                    fontColor: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    maxLines: 1,
                                  ),
                                  const SpaceWidget(spaceWidth: 6),
                                  TextButtonWidget(
                                    onPressed: () {
                                      controller.resendCode();
                                    },
                                    text: 'Resend',
                                    textColor: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink();
                    }),

                    SizedBox(height: AppSize.height(value: 30)),
                    GetBuilder<VerifyOtpScreenController>(
                      builder: (apiControllers) {
                        return Visibility(
                          visible: apiControllers.isLoading == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF3FAE6A),
                            ),
                          ),
                          child: ButtonWidget(
                            onPressed: controller.verifyOtpButton,
                            label: 'Get Verification Code',
                            buttonWidth: double.infinity,
                            buttonRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                            backgroundColor: const Color(0xFF3FAE6A),
                          ),
                        );
                      },
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

  Widget _buildPinCodeTextField(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: PinCodeTextField(
        validator: (value) {
          if (value?.trim().isEmpty == true) {
            return 'Enter Correct Otp';
          }
          return null;
        },
        length: 6,
        textStyle: const TextStyle(color: Colors.black),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        obscureText: false,
        animationType: AnimationType.fade,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),

          activeColor: Colors.grey.shade800,
          inactiveColor: Colors.grey.shade800,
          selectedColor: Colors.black,
          errorBorderColor: Colors.red,

          fieldHeight: 50,
          fieldWidth: 50,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          selectedFillColor: Colors.white,
        ),

        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        controller: controller.otpTextEditingController,
        appContext: context,
      ),
    );
  }
}
