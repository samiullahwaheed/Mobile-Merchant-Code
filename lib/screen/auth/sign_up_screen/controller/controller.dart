import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

class SignUpController extends GetxController {
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  var roleController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectedRole;

  // Checkbox state
  bool isChecked = false;

  void toggleCheckbox() {
    isChecked = !isChecked;
    update();
  }

  // Validate Email
  String? validateEmail(String? value) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value ?? "");
    if (value == null || value.isEmpty) {
      return "Enter Email";
    } else if (!emailValid) {
      return "Enter a valid Email";
    }
    return null;
  }

  // Validate Name
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Name";
    } else if (value.length < 3) {
      return "Name must be at least 3 characters";
    }
    return null;
  }

  // Validate Phone
  String? validatePhone(String? value) {
    bool phoneValid = RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value ?? "");
    if (value == null || value.isEmpty) {
      return "Enter Phone Number";
    } else if (!phoneValid) {
      return "Enter a valid Phone Number";
    }
    return null;
  }

  // Validate Role
  String? validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return "Select a Role";
    }
    return null;
  }





  onTapSignUpButton(){
    if(formKey.currentState!.validate()){
      // Navigate based on selected role
        Get.toNamed(
          AppRoutes.createNewPasswordScreen,
          arguments: {
            'email': emailController.text,
            'phone': phoneController.text,
            'name': nameController.text,
            'role': "MERCENT",
          },
        );
      
    }
  }

}
