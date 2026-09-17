import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/service/repository/update_profile_repository.dart';
import 'package:merchent/utils/app_log/error_log.dart';
import '../../../../../utils/app_log/app_log.dart';
import '../../../../routes/app_routes.dart';
import '../../../../service/repository/auth_repository/forgot_pass_repository.dart';
import '../../../../service/repository/auth_repository/verify_otp_repository.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/verify_otp_model.dart';

class VerifyOtpScreenController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final UpdateProfileRepository _updateProfileRepository =
      UpdateProfileRepository();

  TextEditingController otpTextEditingController = TextEditingController();
  final VerifyOtpRepository _verifyOtpController = Get.put(
    VerifyOtpRepository(),
  );
  final ForgotPassRepository _forgotPassRepository = Get.put(
    ForgotPassRepository(),
  );

  bool isLoading = false;

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  var remainingSeconds = 180.obs; // 2.5 minutes
  var canResend = false.obs;
  late String? phone;
  String? successRoute;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    if (Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      phone = args['phone'] ?? '';
      successRoute = args['successRoute'] as String?;
    } else {
      // Handle the error or provide a default value
      phone = '';
      successRoute = null;
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
      bool isSuccess = await _forgotPassRepository.forgotPass(
        phoneNumber: phone ?? '',
      );
      true;
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

  Future<void> getFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      appLog("FCM TOKEN: $token");
      if (token != null) {
        await _updateProfileRepository.syncFCMToken(token);
      }
    } catch (e) {
      errorLog("Failed to get FCM token: $e");
    }
  }

  /// OnTap Button
  Future<void> verifyOtpButton() async {
    if (formKey.currentState!.validate()) {
      try {
        _setLoading(true);
        String otp = otpTextEditingController.text.trim();

        VerifyOtpModel verifyOtpModel = VerifyOtpModel(
          phone: phone.toString(),
          otp: otp,
        );
        var response = await _verifyOtpController.verifyOtp(
          verifyOtpModel: verifyOtpModel,
          url: AppApiEndPoint.instance.verifyPhoneNumber,
        );

        appLog("response ==> $response");

        if (response != null && response["data"] != null) {
          getFCMToken();
          _setLoading(false);

          AppSnackBar.success('${_verifyOtpController.successfullyMessage}');
          appLog(
            'success message => ${_verifyOtpController.successfullyMessage}',
          );

          AppSnackBar.success("Verification Successful");
          Get.offAllNamed(AppRoutes.signInScreen);
        } else {
          AppSnackBar.message('${_verifyOtpController.errorMessage}');
          _setLoading(false);
          appLog('error message => ${_verifyOtpController.errorMessage}');
        }
      } catch (e) {
        AppSnackBar.message('${_verifyOtpController.errorMessage}');
        _setLoading(false);
      }
    } else {
      AppSnackBar.error("Please fill in all required fields.");
      _setLoading(false);
    }
  }
}
