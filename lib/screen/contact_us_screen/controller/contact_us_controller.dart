import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/profile_section/profile_screen/controller/profile_controller.dart';
import '../../../service/repository/auth_repository/contact_us_repository.dart';
import '../../../utils/app_log/app_log.dart';
import '../../../widget/app_snack_bar/app_snack_bar.dart';
import '../model/contact_us_model.dart';

class ContactUsController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final ProfileController profileController = Get.find<ProfileController>();

  final ContactUsRepository _contactUsRepository = Get.put(
    ContactUsRepository(),
  );

  bool inProgress = false;

  
  // Validate Subject
  String? validateSubject(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter subject";
    }
    return null;
  }

  // Validate Message
  String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your message";
    }
    return null;
  }

  Future<void> onTapSaveButton() async {
    if (formKey.currentState!.validate()) {
      try {
        inProgress = true;
        update(); // Update UI for GetBuilder

        ContactUsModel contactUsModel = ContactUsModel(
          name: profileController.profile.value?.firstName ?? '',
          email: profileController.profile.value?.email ?? '',
          subject: subjectController.text.trim(),
          message: messageController.text.trim(),
        );

        appLog('Submitting contact us form for: ${nameController.text.trim()}');

        final int statusCode = await _contactUsRepository.contactUsApiCall(
          contactUsModel: contactUsModel,
        );

        inProgress = false;
        update(); // Update UI for GetBuilder

        appLog('Contact Us response status code: $statusCode');

        if (statusCode == 200 || statusCode == 201) {
          // ✅ Success
          appLog('Contact Us submitted successfully');

          AppSnackBar.success(
            _contactUsRepository.successfullyMessage.isNotEmpty
                ? _contactUsRepository.successfullyMessage
                : 'Contact message submitted successfully!',
          );

          Get.close(1);

          // Clear all form fields
          nameController.clear();
          emailController.clear();
          subjectController.clear();
          messageController.clear();
        } else {
          // ❌ Error
          appLog('Contact Us failed with status code: $statusCode');

          AppSnackBar.message(
            _contactUsRepository.errorMessage.isNotEmpty
                ? _contactUsRepository.errorMessage
                : "Failed to submit. Please try again.",
          );
        }
      } catch (e, stackTrace) {
        inProgress = false;
        update(); // Update UI for GetBuilder

        appLog('Exception in Contact Us: $e');
        appLog('StackTrace: $stackTrace');

        AppSnackBar.message('Something went wrong. Please try again.');
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
