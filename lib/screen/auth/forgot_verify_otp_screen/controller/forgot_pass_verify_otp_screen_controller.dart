import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/routes/app_routes.dart';
import 'package:merchent/screen/auth/forgot_verify_otp_screen/repository/forget_pass_verify_otp_repository.dart';
import 'package:merchent/widget/app_log/error_log.dart';
import '../../../../../utils/app_log/app_log.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';

class ForgotPassVerifyOtpScreenController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpTextEditingController = TextEditingController();
  late String phone;

  final ForgetPassVerifyOtpRepository _forgetPassVerifyOtpRepository =
      ForgetPassVerifyOtpRepository.instance;

  var remainingSeconds = 180.obs; // 2.5 minutes
  var canResend = false.obs;
  // late String email;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    if (Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      phone = args['phone'] ?? '';
    } else {
      // Handle the error or provide a default value
      phone = '';
    }
  }

 
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        
      } else {
        canResend.value = true;
        appLog("Timer completed. You can resend the code now."); // Debugging
        _timer.cancel();
      }
    });
  }

  /// Resent Otp code
  void resendCode() async {
    try {
      bool isSuccess = /*await AuthRepository().resendOtp(email: email);*/ true;
      if (isSuccess) {
        AppSnackBar.success("A new OTP has been sent to your phone number.");
        remainingSeconds.value = 180; // Reset the timer
        canResend.value = false;
        startTimer(); // Restart the timer
      }
    } catch (e) {
      AppSnackBar.error("An error occurred. Please try again.");
    }
  }

  String formatTime() {
    final minutes = remainingSeconds.value ~/ 60;
    final remainingSec = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSec.toString().padLeft(2, '0')}';
  }

  RxBool isLoading = false.obs;

  Future<void> onTapForgotPassVerifyButton() async {
    try {
      isLoading.value = true;
      if (otpTextEditingController.text.trim().isEmpty) {
        AppSnackBar.error(
          "Please enter the code sent to your phone number to continue.",
        );
        return;
      }
      final response = await _forgetPassVerifyOtpRepository.verifyOtp(
        otp: otpTextEditingController.text.trim(),
        email: phone,
      );
      if (response != null && response["data"] != null) {
        String token = response["data"]?["resetToken"];
        // AppSnackBar.success(token);
        Get.toNamed(AppRoutes.resetPasswordScreen, arguments: {'token': token});
      }
    } catch (e) {
      errorLog("Error in onTapForgotPassVerifyButton: $e", e);
    } finally {
      isLoading.value = false;
    }
  }
}
