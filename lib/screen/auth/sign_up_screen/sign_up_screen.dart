import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchent/widget/app_snack_bar/app_snack_bar.dart';
import 'package:merchent/widget/text_field_widget/email_and_phone_field.dart';
import '../../../widget/button_widget/button_widget.dart';
import '../authentications_screen.dart';
import 'controller/controller.dart';
import '../../../widget/auth_top_round_widget.dart';
import '../../../widget/text_button_widget/text_button_widget.dart';
import '../../../widget/text_field_widget/text_field_widget.dart';
import '../../common_widget/common_text_widget.dart';
import '../../common_widget/dev_logo_text.dart';
import '../../../utils/app_size.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF3FAE6A), // Green background
        statusBarIconBrightness: Brightness.light, // White icons on Android
        statusBarBrightness: Brightness.dark, // White icons on iOS
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.start, // 👈 Left align
          children: [SafeArea(child: PrivacyPolicyWidget())],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Top Section
              // SizedBox(
              //   // height: AppSize.height(value: 300),
              //   child: Stack(
              //     children: [
              //       TopRoundWidget(
              TopRoundWidget(
                hasAppBar: false,
                height: AppSize.height(value: 300),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 22,
                    right: 22,
                    top: 0, // You can adjust this from outside
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSize.height(value: 48)),
                      TextWidget(
                        textAlignment: TextAlign.left,
                        text: "Join Miltech Today!",
                        fontSize: AppSize.width(value: 30),
                        fontWeight: FontWeight.w700,
                        fontColor: Colors.white,
                      ),
                      TextWidget(
                        textAlignment: TextAlign.left,
                        text: "Unlock Rewards, Start Earning Now!",
                        fontSize: AppSize.width(value: 18),
                        fontWeight: FontWeight.w400,
                        fontColor: Colors.white,
                      ),
                      Center(
                        child: DevLogoText(
                          textAlignment: TextAlign.center,
                          logoSize: 70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Form & Button Section
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
                child: Column(
                  children: [
                    buildForm(),

                    SizedBox(height: AppSize.height(value: 15)),
                    GetBuilder<SignUpController>(
                      builder: (apiControllers) {
                        return Visibility(
                          // visible: apiControllers.inProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: apiControllers.isChecked
                              ? ButtonWidget(
                                  onPressed: signUpController.onTapSignUpButton,
                                  label: 'Sign Up',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  buttonWidth: double.infinity,
                                  buttonRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  backgroundColor: Color(0xFF3FAE6A),
                                )
                              : ButtonWidget(
                                  onPressed: () {
                                    AppSnackBar.message(
                                      'Please agree to the terms and conditions',
                                    );
                                  },
                                  label: 'Sign Up',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  buttonWidth: double.infinity,
                                  buttonRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  backgroundColor: Color(
                                    0xFF3FAE6A,
                                  ).withValues(alpha: .5),
                                ),
                        );
                      },
                    ),

                    /* CommonElevatedButton(
                    text: 'Sign Up',
                    width: double.infinity,
                    onPressed: () {Get.toNamed(AppRoutes.createNewPasswordScreen);},
                    backgroundColor: AppColor.backgroundColor,
                    borderRadius: 100,
                  ),*/
                    SizedBox(height: AppSize.height(value: 15)),
                    buildTermsCheckbox(),
                    //SizedBox(height: AppSize.height(value: 40)),
                    buildSignInPromptSection(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Terms Checkbox
  Row buildTermsCheckbox() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GetBuilder<SignUpController>(
          builder: (controller) {
            return GestureDetector(
              onTap: () {
                controller
                    .toggleCheckbox(); // Update checkbox state in controller
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: controller.isChecked
                      ? Colors.green
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: controller.isChecked
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        TextWidget(
          textAlignment: TextAlign.left,
          text: "I agree to (Company Name) Terms & \nConditions. ",

          maxLines: 2,
          fontSize: AppSize.width(value: 16),
          fontWeight: FontWeight.w400,
          fontColor: Colors.black,
        ),
        // Flexible(
        //   child: RichText(
        //     text: const TextSpan(
        //       style: TextStyle(color: Colors.black, fontSize: 16),
        //       children: [
        //         TextSpan(text: "I agree to "),
        //         TextSpan(
        //           text: "(Company Name) Terms & Conditions.",
        //           style: TextStyle(fontWeight: FontWeight.bold),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // Sign-In Prompt
  Widget buildSignInPromptSection(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextWidget(
            text: 'Already Have an Account?',
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButtonWidget(
            onPressed: () {
              // Navigation to Sign In screen here
              Navigator.pop(context);
            },
            text: 'Sign In',
            textColor: Color(0xFF3FAE6A),
            fontSize: AppSize.width(value: 18),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // Sign Up Form
  Widget buildForm() {
    return Form(
      key: signUpController.formKey,
      child: Column(
        children: [
          TextFieldWidget(
            height: 50,
            validator: signUpController.validateName,
            controller: signUpController.nameController,
            hintText: 'Name',
            keyboardType: TextInputType.text,
            maxLines: 1,
            borderColor: Color(0xFF3FAE6A),
          ),

          SizedBox(height: AppSize.height(value: 15)),

          TextFieldWidget(
            height: 50,
            controller: signUpController.emailController,
            hintText: 'Email',
            maxLines: 1,
            validator: signUpController.validateEmail,
            prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF3FAE6A)),
            borderColor: Color(0xFF3FAE6A),
          ),

          SizedBox(height: AppSize.height(value: 15)),

          EmailAndPhoneField(
            controller: signUpController.phoneController,
            alwaysPhone: true, // শুধু phone field দেখাবে
            allowedCountryCodes: ["PK"],
            defaultCountryCode: 'PK',
            fillColor: Colors.grey[100],

            borderRadius: 24,
            isOptional: false,
            validator: signUpController.validatePhone,
          ),
        ],
      ),
    );
  }
}
