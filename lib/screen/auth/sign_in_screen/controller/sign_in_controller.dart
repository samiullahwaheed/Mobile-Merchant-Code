import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../service/repository/auth_repository/sign_in_repository.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../../../service/repository/update_profile_repository.dart';
import '../../../../utils/app_log/error_log.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/sign_in_model.dart';

class SignInController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SignInApiController _signInController = Get.put(SignInApiController());
  final UpdateProfileRepository _updateProfileRepository =
      UpdateProfileRepository();

  bool inProgress = false;



  onInit() {
    super.onInit();
  }

  // Validate Password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Password";
    } else if (value.length < 6) {
      return "Password length should be more than 8 characters";
    }
    return null;
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

  Future<void> onTapSignInButton() async {
    if (formKey.currentState!.validate()) {
      try {
        inProgress = true;
        update(); // Update UI for GetBuilder

        SignInModel signInModel = SignInModel(
          email: emailController.text.trim(),
          password: passwordController.text,
          deviceId: "merchant",
        );

        appLog('Attempting login for: ${emailController.text.trim()}');

        final dynamic response = await _signInController.signInApiCall(
          signInModel: signInModel,
          email: emailController.text.trim(),
        );

        inProgress = false;

        update(); // Update UI for GetBuilder

        // appLog('Login response status code: $statusCode');

        // 400 ও 407 আগে check করতে হবে, কারণ এগুলো int return করে
        // response != null সত্য হলে response['user'] চালালে int এ exception হবে
        if (response == 400) {
          appLog('Invalid credentials');
          AppSnackBar.message(
            _signInController.errorMessage.isNotEmpty
                ? _signInController.errorMessage
                : "Invalid credentials. Please try again.",
          );
        } else if (response == 407) {
          appLog('OTP verification required');
          AppSnackBar.message(
            _signInController.errorMessage.isNotEmpty
                ? _signInController.errorMessage
                : "OTP verification required.",
          );
          Get.toNamed(
            AppRoutes.signupVerifyOtpScreen,
            arguments: {'email': emailController.text.trim()},
          );
        } else if (response != null && response is Map) {
          // ✅ Success - 200 (response = data Map)
          appLog('Login successful, navigating to business bottom nav');

          final String? businessName = response['user']?['businessName'];
          final bool isBusiness =
              businessName != null && businessName.isNotEmpty;
          final bool location =
              response['user']?['location']?['coordinates'] != null &&
              response['user']?['location']?['coordinates']!.isNotEmpty &&
              response['user']?['location']?['coordinates']![0] == 0.0 &&
              response['user']?['location']?['coordinates']![1] == 0.0;

          AppSnackBar.success(
            _signInController.successfullyMessage.isNotEmpty
                ? _signInController.successfullyMessage
                : 'Login Successful!',
          );
          await getFCMToken();

          emailController.clear();
          passwordController.clear();

          if (!isBusiness) {
            // Get.offAllNamed(AppRoutes.locationScreen);
            Get.offAllNamed(AppRoutes.shopInformationScreen);
          } else if (location) {
            Get.offAllNamed(AppRoutes.locationScreen);
            // Get.offAllNamed(AppRoutes.shopInformationScreen);
          } else {
            Get.offAllNamed(AppRoutes.userBottomNav);
          }
        } else {
          // ❌ Other errors (401, 500, etc - response = status code int)
          appLog('Login failed with status code: $response');
          AppSnackBar.message(
            _signInController.errorMessage.isNotEmpty
                ? _signInController.errorMessage
                : "Login failed. Please try again.",
          );
        }
      } catch (e, stackTrace) {
        inProgress = false;
        update(); // Update UI for GetBuilder

        appLog('Exception in SignIn: $e');
        appLog('StackTrace: $stackTrace');

        AppSnackBar.message('Something went wrong. Please try again.');
      }
    }
  }
}
