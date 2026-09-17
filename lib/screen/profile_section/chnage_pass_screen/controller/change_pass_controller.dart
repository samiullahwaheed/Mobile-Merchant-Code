import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_log/app_log.dart';
import '../../../../constant/app_api_end_point.dart';
import '../../../../routes/app_routes.dart';
import '../../../../service/repository/auth_repository/reset_paa_repository.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';
import '../../../auth/reset_password_screen/model/reset_pass_model.dart';
import '../../../../service/storage/storage_service.dart';

class ChnagePasswordController extends GetxController {
  final UserResetPasswordRepository _userResetPasswordRepository = Get.put(
    UserResetPasswordRepository(),
  );
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Validate Old Password
  String? validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Old Password";
    }
    return null;
  }

  // Validate New Password (same rules as sign-up / create password)
  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter New Password";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least 1 uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least 1 lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least 1 number";
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return "Password must contain at least 1 special character";
    }
    return null;
  }

  // Validate Confirm Password - shows "Passwords do not match" at field level
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm your Password";
    }
    if (value != newPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> onTapResetButton() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    appLog(newPasswordController.text);
    appLog(confirmPasswordController.text);

    final String token = LocalStorage.token;
    if (token.isEmpty) {
      AppSnackBar.error("Session expired. Please log in again.");
      Get.offAllNamed(AppRoutes.signInScreen);
      return;
    }

    final Map<String, String> resetToken = {"Authorization": "Bearer $token"};

    ResetPasswordModel resetPasswordModel = ResetPasswordModel(
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
      oldPassword: oldPasswordController.text,
    );

    final bool isSuccess = await _userResetPasswordRepository
        .resetPasswordApiCaller(
          url: AppApiEndPoint.instance.resetPassword,
          resetPasswordModel: resetPasswordModel,
          resetToken: resetToken,
        );

    if (isSuccess) {
      AppSnackBar.success(
        '${_userResetPasswordRepository.successfullyMessage}',
      );

      appLog(
        'success message ===> ${_userResetPasswordRepository.successfullyMessage} <===',
      );

      Get.close(1);

      // Get.offAllNamed(AppRoutes.signInScreen);
    } else {
      AppSnackBar.message('${_userResetPasswordRepository.errorMessage}');
      appLog('error message => ${_userResetPasswordRepository.errorMessage}');
    }
  }
}
