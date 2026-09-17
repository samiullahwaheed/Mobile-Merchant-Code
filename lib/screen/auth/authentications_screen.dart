import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import 'package:merchent/screen/common_widget/dev_logo_text.dart';
import 'package:merchent/service/storage/get_storage_services.dart';
import '../../routes/app_routes.dart';
import '../../widget/auth_top_round_widget.dart';

class AuthenticationsScreen extends StatefulWidget {
  const AuthenticationsScreen({super.key});

  @override
  State<AuthenticationsScreen> createState() => _AuthenticationsScreenState();
}

class _AuthenticationsScreenState extends State<AuthenticationsScreen> {
  @override
  void initState() {
    super.initState();
    GetStorageServices.instance.isUserFirstTime(true);
  }

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
          children: [SafeArea(child: const PrivacyPolicyWidget())],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopRoundWidget(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: const DevLogoText()),
                    TextWidget(
                      textAlignment: TextAlign.center,
                      text: "Let's Get Started!",
                      fontSize: isTablet ? 32 : (isSmallScreen ? 20 : 24),
                      fontWeight: FontWeight.w700,
                      fontColor: Colors.white,
                    ),
                    TextWidget(
                      text: "Let's dive in into your account",
                      fontSize: isTablet ? 20 : (isSmallScreen ? 14 : 18),
                      fontWeight: FontWeight.w500,
                      fontColor: Colors.white,
                    ),
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
                  vertical: isSmallScreen ? 12 : 18,
                ),
                child: Column(
                  children: [
                    SizedBox(height: isSmallScreen ? 20 : (isTablet ? 40 : 30)),

                    Center(
                      child: buildContainerMethod(
                        text: "Sign In ➔",
                        function: () => Get.toNamed(AppRoutes.signInScreen),
                        context: context,
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 15 : 20),

                    buildContainerMethod(
                      text: "Sign Up ➔",
                      backgroundColor: const Color(0xFFD7F4DE),
                      textColor: Colors.black,
                      function: () => Get.toNamed(AppRoutes.signUpScreen),
                      context: context,
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

  Widget buildContainerMethod({
    Color? backgroundColor,
    required String text,
    Color? textColor,
    required VoidCallback function,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenHeight < 400;
    final isMobile = screenWidth < 400;

    return GestureDetector(
      onTap: function,
      child: Container(
        width: double.infinity,
        height: isTablet ? 64 : (isSmallScreen ? 48 : 54),
        decoration: ShapeDecoration(
          color: backgroundColor ?? const Color(0xFF3FAE6A),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFF198248)),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Center(
          child: TextWidget(
            text: text,
            fontColor: textColor ?? Colors.white,
            fontSize: isTablet ? 20 : (isMobile ? 16 : 18),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isMobile = screenWidth < 400;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(maxWidth: isTablet ? 500 : double.infinity),
        margin: isTablet
            ? EdgeInsets.symmetric(horizontal: (screenWidth - 500) / 2)
            : EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: isMobile
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.termsAndConditionScreen,
                    arguments: 'terms-and-conditions',
                  );
                },
                child: TextWidget(
                  text: 'Terms & Conditions',
                  fontSize: isTablet ? 14 : (isMobile ? 12 : 12),
                  fontWeight: FontWeight.w400,
                  underline: true,
                ),
              ),

              SizedBox(width: isMobile ? 16 : 8),

              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.termsAndConditionScreen,
                    arguments: 'privacy-policy',
                  );
                },
                child: TextWidget(
                  text: 'Privacy Policy',
                  fontSize: isTablet ? 14 : (isMobile ? 12 : 12),
                  fontWeight: FontWeight.w400,
                  underline: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
