import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import 'package:merchent/widget/appbar_widget/appbar_widget.dart';
import 'package:merchent/widget/text_field_widget/text_field_widget.dart';
import '../../../../utils/app_size.dart';
import '../../../../widget/app_button/app_button.dart';
import '../../constant/app_color/app_color.dart';
import '../../constant/app_color/app_theme_color.dart';
import 'controller/contact_us_controller.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    return GetBuilder<ContactUsController>(
      init: ContactUsController(),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppbarWidget(
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back_ios_new, color: appThemeColor.text2),
            ),
            showLeading: true,
            backgroundColor: appThemeColor.text1,
            textWidget: TextWidget(
              text: "Contact Us",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textAlignment: TextAlign.center,
              fontColor: appThemeColor.text2,
            ),
          ),
          body: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppSize.width(value: 16)),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .1),
                          offset: Offset(0, 2),
                          blurRadius: 8,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .1),
                          offset: Offset(0, -2),
                          blurRadius: 8,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                        AppSize.width(value: 12),
                      ),
                      color: AppColor.surfacePrimaryLight,
                    ),
                    padding: EdgeInsets.all(AppSize.width(value: 20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSize.size.height * 0.01,
                      children: [
                        TextWidget(
                          text: 'Full Name',
                          fontWeight: FontWeight.w500,
                        ),
                        TextFieldWidget(
                          readOnly: true,

                          borderRadius: 8,
                          height: 54,
                          controller: TextEditingController(
                            text: controller
                                .profileController
                                .profile
                                .value
                                ?.firstName,
                          ),
                          hintText: "Enter Name",
                        ),
                        TextWidget(text: 'Email', fontWeight: FontWeight.w500),
                        TextFieldWidget(
                          readOnly: true,
                          borderRadius: 8,
                          height: 54,
                          controller: TextEditingController(
                            text: controller
                                .profileController
                                .profile
                                .value
                                ?.email,
                          ),
                          hintText: "Enter Email",
                        ),
                        TextWidget(
                          text: 'Subject',
                          fontWeight: FontWeight.w500,
                        ),
                        TextFieldWidget(
                          borderRadius: 8,
                          height: 54,
                          controller: controller.subjectController,
                          hintText: "Write Your Subject",
                          validator: controller.validateSubject,
                        ),
                        TextWidget(
                          text: 'Feedback',
                          fontWeight: FontWeight.w500,
                        ),
                        TextFieldWidget(
                          borderRadius: 8,
                          height: 54,
                          controller: controller.messageController,
                          maxLines: 3,
                          hintText: "Write Your Feedback Here",
                          validator: controller.validateMessage,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 16),
                vertical: AppSize.width(value: 20),
              ),
              child: AppButton(
                filColor: appThemeColor.icon,
                titleColor: appThemeColor.text1,
                title: "Save",

                titleSize: AppSize.width(value: 18),
                borderRadius: BorderRadius.circular(AppSize.width(value: 24)),
                onTap: controller.inProgress
                    ? null
                    : controller.onTapSaveButton,
                isLoading: controller.inProgress,
              ),
            ),
          ),
        );
      },
    );
  }
}
