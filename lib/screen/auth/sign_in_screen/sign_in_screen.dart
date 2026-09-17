import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchent/routes/app_routes.dart';
import 'package:merchent/screen/auth/sign_in_screen/controller/sign_in_controller.dart';
import 'package:merchent/utils/app_size.dart';
import '../../../service/repository/auth_repository/sign_in_repository.dart';
import '../../../widget/auth_top_round_widget.dart';
import '../../../widget/button_widget/button_widget.dart';
import '../../../widget/text_button_widget/text_button_widget.dart';
import '../../../widget/text_field_widget/text_field_widget.dart';
import '../../common_widget/common_text_widget.dart';
import '../../common_widget/dev_logo_text.dart';
import '../authentications_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInController controller = Get.put(SignInController());

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenHeight < 700;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF3FAE6A), // Green background
        statusBarIconBrightness: Brightness.light, // White icons on Android
        statusBarBrightness: Brightness.dark, // White icons on iOS
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.start, // 👈 Left align
          children: [
            SafeArea(child: Row(children: [PrivacyPolicyWidget()])),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopRoundWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextWidget(
                        text: "Welcome Back!",
                        textAlignment: TextAlign.start,
                        fontSize: AppSize.width(value: 40),
                        fontWeight: FontWeight.w700,
                        fontColor: Colors.white,
                      ),
                    ),
                    const Center(child: DevLogoText()),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 500 : double.infinity,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 18,
                  vertical: 18,
                ),
                child: Column(
                  children: [
                    buildForm(context),
                    SizedBox(
                      height: AppSize.height(value: isSmallScreen ? 15 : 20),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButtonWidget(
                        onPressed: () =>
                            Get.toNamed(AppRoutes.forgotPasswordScreen),
                        text: "Forgot Password",
                        textColor: const Color(0xFF3FAE6A),
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: AppSize.height(value: isSmallScreen ? 15 : 20),
                    ),
                    GetBuilder<SignInApiController>(
                      builder: (controllers) {
                        return Visibility(
                          visible: controllers.inProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF3FAE6A),
                            ),
                          ),
                          child: ButtonWidget(
                            backgroundColor: const Color(0xFF3FAE6A),
                            onPressed: controller.onTapSignInButton,
                            label: 'Sign In',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            buttonWidth: double.infinity,
                            buttonRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppSize.height(value: 50)),
                    buildSignUpPromptSection(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// SignUp Prompt Section
  Column buildSignUpPromptSection(BuildContext contex) {
    final screenWidth = MediaQuery.of(contex).size.width;
    final isTablet = screenWidth > 600;
    final isMobile = screenWidth < 400;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextWidget(
            text: "Don't Have an Account?",
            fontWeight: FontWeight.w500,
            fontSize: isTablet ? 14 : (isMobile ? 11 : 12),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButtonWidget(
            onPressed: () {
              Get.toNamed(AppRoutes.signUpScreen);
            },
            text: 'Sign Up',
            textColor: const Color(0xFF3FAE6A),
            fontSize: isTablet ? 20 : (isMobile ? 16 : 18),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// Text Field Form
  Widget buildForm(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          TextFieldWidget(
            height: AppSize.height(value: 54),
            controller: controller.emailController,
            hintText: 'Email Or Phone Number',
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
          ),
          SizedBox(height: AppSize.height(value: isSmallScreen ? 15 : 20)),
          TextFieldWidget(
            height: AppSize.height(value: 54),
            keyboardType: TextInputType.visiblePassword,
            controller: controller.passwordController,
            hintText: 'Password',
            maxLines: 1,
            suffixIcon: true,
          ),
        ],
      ),
    );
  }
}
