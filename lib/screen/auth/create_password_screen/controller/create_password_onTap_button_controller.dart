import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_log/app_log.dart';
import '../../../../routes/app_routes.dart';
import '../../../../service/repository/auth_repository/sign_up_api_repository.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';
import '../../sign_up_screen/model/sign_up_model.dart';

class CreatePasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late final SignUpApiController _userSignUpApiController;

  // Validate New Password
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

  // Validate Confirm Password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm your Password";
    } else if (value != newPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  // late String token;
  late String email;
  late String phone;
  late String name;

  @override
  void onInit() {
    super.onInit();
    _userSignUpApiController = Get.put(SignUpApiController());
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      // token = Get.arguments['token'] ?? '';
      email = Get.arguments['email'] ?? '';
      phone = Get.arguments['phone'] ?? '';
      name = Get.arguments['name'] ?? '';
    } else {
      // token = '';
      email = '';
      phone = '';
      name = '';
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }


  Future<void> onTapSignUpButton() async {
    if (formKey.currentState!.validate()) {
      SignUpModel userSignUpModel = SignUpModel(
        name: name,
        email: email,
        number: phone,
        password: confirmPasswordController.text,
        role: "MERCHANT",
      );

      isLoading = true;
      update(); // ✅ show loading

      final bool isSuccess = await _userSignUpApiController.userSignUp(
        userSignUpModel,
      );

      isLoading = false;
      update(); // ✅ hide loading

      if (isSuccess) {
        AppSnackBar.success(
          _userSignUpApiController.successfullyMessage ?? 'Successful!',
        );
        appLog(
          'success message => ${_userSignUpApiController.successfullyMessage}',
        );

        Get.toNamed(
          AppRoutes.verifyOtpScreen,
          arguments: {'phone': phone, 'successRoute': AppRoutes.locationScreen},
        );
      } else {
        AppSnackBar.message('${_userSignUpApiController.errorMessage}');
        appLog('error message => ${_userSignUpApiController.errorMessage}');
      }
    }
  }
}
