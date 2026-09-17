import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/constant/app_image_path.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import 'package:merchent/widget/appbar_widget/appbar_widget.dart';
import '../../../constant/app_color/app_color.dart';
import '../../../constant/app_color/app_theme_color.dart';
import '../../../utils/app_size.dart';
import '../../../widget/app_button/app_button.dart';
import '../../../widget/app_image/app_image.dart';
import '../../../widget/text_field_widget/text_field_widget.dart';
import 'controller/change_pass_controller.dart';

class ChangePassScreen extends StatelessWidget {
  final ChnagePasswordController changePassController = Get.put(
    ChnagePasswordController(),
  );

  ChangePassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.width(value: 16),
            vertical: AppSize.width(value: 20),
          ),
          child: AppButton(
            onTap: () => changePassController.onTapResetButton(),
            filColor: appThemeColor.icon,
            titleColor: appThemeColor.text1,
            title: "Save",

            titleSize: AppSize.width(value: 18),
            borderRadius: BorderRadius.circular(AppSize.width(value: 24)),
          ),
        ),
      ),
      // appBar: CustomAppbar(
      //   text: "Change Password",
      //   appThemeColor: appThemeColor,
      // ),
      appBar: AppbarWidget(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new, color: appThemeColor.text2),
        ),
        backgroundColor: appThemeColor.text1,
        text: "Change Password",
        textWidget: TextWidget(
          text: "Change Password",
          fontSize: 18,
          fontWeight: FontWeight.w700,
          textAlignment: TextAlign.center,
          fontColor: appThemeColor.text2,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppImage(
              width: AppSize.size.width * 0.6,
              path: AppImagePath.changePassImg,
              color: appThemeColor.text1,
            ),

            Padding(
              padding: EdgeInsets.all(AppSize.width(value: 16)),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .1), // Shadow color
                      offset: Offset(
                        0,
                        2,
                      ), // Vertical offset, giving shadow on bottom
                      blurRadius: 8, // Blur radius
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .1), // Shadow color
                      offset: Offset(
                        0,
                        -2,
                      ), // Vertical offset, giving shadow on top
                      blurRadius: 8, // Blur radius
                    ),
                  ],
                  borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
                  color: AppColor.surfacePrimaryLight,
                ),
                padding: EdgeInsets.all(AppSize.width(value: 20)),
                child: Form(
                  key: changePassController.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSize.size.height * 0.01,
                    children: [
                      TextWidget(
                        text: 'Old Password',
                        fontWeight: FontWeight.w500,
                      ),
                      TextFieldWidget(
                        height: 54,
                        borderRadius: 8,
                        controller: changePassController.oldPasswordController,
                        hintText: "Old Password",
                        validator: changePassController.validateOldPassword,
                        suffixIcon: true,
                      ),

                      TextWidget(
                        text: 'New Password',
                        fontWeight: FontWeight.w500,
                      ),
                      TextFieldWidget(
                        borderRadius: 8,
                        controller: changePassController.newPasswordController,
                        hintText: "New Password",
                        height: 54,
                        validator: changePassController.validateNewPassword,
                        suffixIcon: true,
                        onChanged: (_) => changePassController
                            .formKey.currentState
                            ?.validate(),
                      ),

                      TextWidget(
                        text: 'Confirm Password',
                        fontWeight: FontWeight.w500,
                      ),

                      TextFieldWidget(
                        borderRadius: 8,
                        height: 54,
                        controller:
                            changePassController.confirmPasswordController,
                        hintText: "Enter Confirm Password",
                        validator: changePassController.validateConfirmPassword,
                        suffixIcon: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
