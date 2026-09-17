import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merchent/constant/app_image_path.dart';
import 'package:merchent/routes/app_routes.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import 'package:merchent/widget/appbar_widget/appbar_widget.dart';
import 'package:merchent/widget/text_field_widget/text_field_widget.dart';
import '../../../constant/app_color/app_theme_color.dart';
import '../../../constant/app_color/assets_icons_path.dart';
import '../../../constant/app_color/theme_controller.dart';
import '../../../utils/app_size.dart';
import '../../../widget/app_button/app_button.dart';
import '../../../widget/app_image/app_image.dart';
import '../../../widget/app_image/app_image_circular.dart';
import '../../../widget/app_log/gap.dart';
import '../../../widget/app_text/app_text.dart';
import '../../../widget/showCustomDialog.dart';
import 'controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  // কন্ট্রোলার বিল্ড মেথডের বাইরে ফাইনাল হিসেবে ডিফাইন করা হয়েছে
  final ProfileController profileController = Get.put(ProfileController());
  final ThemeController themeController = Get.put(ThemeController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // বর্তমান থিম ডাটা নেওয়া হচ্ছে
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: appThemeColor.surfacePrimary,
        showLeading: false,
        textWidget: TextWidget(
          text: 'Profile',
          fontSize: AppSize.width(value: 18),
          fontWeight: FontWeight.w700,
          fontColor: appThemeColor.text2,
        ),
      ),
      body: Obx(() {
        final user = profileController.profile.value;
        var imageUrl = profileController.resolveProfileImage(user);

        // এটি অ্যাসেট নাকি নেটওয়ার্ক ইউআরএল তা চেক করা হচ্ছে
        final bool isAsset =
            !imageUrl.startsWith('http://') && !imageUrl.startsWith('https://');

        // 💡 নোট: স্ক্রিনশটের রিপোর্ট অনুযায়ী, Obx এর ভেতর প্রতিবার DateTime.now() 
        // ব্যবহার করে ক্যাশ-বাস্টিং ইউআরএল তৈরি করলে ডুপ্লিকেট নেটওয়ার্ক লোড তৈরি হয়।
        // তাই স্ক্রিন থেকে সরাসরি টাইমস্ট্যাম্প জেনারেশন বাদ দেওয়া হয়েছে। 
        // প্রোফাইল পিকচার আপডেট হলে তা কন্ট্রোলারের মাধ্যমে হ্যান্ডেল করাই শ্রেয়।

        final primaryName = (() {
          final firstName = user?.firstName ?? '';
          if (firstName.isNotEmpty) return firstName;
          final businessName = user?.businessName ?? '';
          if (businessName.isNotEmpty) return businessName;
          return 'User';
        })();

        final primaryPhone = (() {
          final phone = user?.phone ?? '';
          if (phone.isNotEmpty) return phone;
          final referenceId = user?.referenceId ?? '';
          if (referenceId.isNotEmpty) return referenceId;
          return '';
        })();

        final city = user?.city ?? '';
        final country = user?.country ?? '';
        final streetAddress = user?.address ?? '';

        double? savedLat;
        double? savedLng;
        final coords = user?.location?.coordinates;
        if (coords != null && coords.length >= 2) {
          savedLng = coords[0];
          savedLat = coords[1];
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(AppSize.width(value: 16)),
                child: Row(
                  children: [
                    AppImageCircular(
                      fit: BoxFit.cover,
                      url: isAsset ? null : imageUrl,
                      path: isAsset ? imageUrl : null,
                      width: AppSize.width(value: 124),
                      height: AppSize.width(value: 124),
                    ),
                    Gap(width: AppSize.width(value: 20)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSize.size.height * 0.014,
                      children: [
                        AppText(
                          data: primaryName,
                          fontSize: AppSize.width(value: 18),
                          fontWeight: FontWeight.w700,
                          color: appThemeColor.text2,
                        ),
                        AppText(
                          data: primaryPhone.isNotEmpty ? primaryPhone : 'N/A',
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w500,
                          color: appThemeColor.text2,
                        ),
                        if (profileController.role == "ADMIN_MERCHANT" ||
                            profileController.role == "MERCHANT")
                          AppButton(
                            title: 'Edit Profile',
                            width: AppSize.size.width * 0.3,
                            height: AppSize.size.width * 0.1,
                            titleColor: appThemeColor.text1,
                            onTap: () async {
                              final result = await Get.toNamed(
                                AppRoutes.changeProfileScreen,
                                arguments: {
                                  'name': primaryName,
                                  'phone': primaryPhone,
                                  'email': user?.email ?? '',
                                  'address': streetAddress,
                                  'country': country,
                                  'city': city,
                                  if (savedLat != null) 'latitude': savedLat,
                                  if (savedLng != null) 'longitude': savedLng,
                                  'profileImage': imageUrl,
                                },
                              );

                              if (result == true) {
                                // 💡 ডাটা রিফ্রেশ করার জন্য মেথড কল। 
                                // নিশ্চিত করুন ProfileController.fetchProfile() মেথডের ভেতরে 
                                // যেন অপ্রয়োজনীয় ডুপ্লিকেট কল না হয়ে সরাসরি ক্যাশ আপডেট হয়।
                                profileController.fetchProfile();
                              }
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: appThemeColor.surfacePrimary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, -2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(AppSize.width(value: 24)),
                child: Column(
                  spacing: AppSize.size.height * 0.03,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileRow(
                      appThemeColor: appThemeColor,
                      iconData: Icons.lock,
                      onTap: () => Get.toNamed(AppRoutes.changePassScreen),
                      text: "Password",
                    ),
                    ProfileRow(
                      appThemeColor: appThemeColor,
                      iconData: Icons.palette_outlined,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Column(
                                spacing: AppSize.size.height * 0.01,
                                children: [
                                  const Icon(Icons.palette, size: 100),
                                  AppText(
                                    data: "Customize Your Appearance",
                                    fontSize: AppSize.width(value: 18),
                                    fontWeight: FontWeight.w700,
                                    color: appThemeColor.text2,
                                  ),
                                  AppText(
                                    data: "Customize your experience by adjusting theme.",
                                    fontSize: AppSize.width(value: 16),
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                    color: appThemeColor.text2,
                                  ),
                                  Row(
                                    spacing: AppSize.width(value: 12),
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            AppImage(path: AssetsPath.themeLight),
                                            Row(
                                              children: [
                                                Radio<bool>(
                                                  value: false,
                                                  groupValue: themeController.isDark.value,
                                                  onChanged: (bool? value) {
                                                    themeController.changeTheme();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                AppText(
                                                  data: "Light Mode",
                                                  fontSize: AppSize.width(value: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            AppImage(path: AssetsPath.themeDark),
                                            Row(
                                              children: [
                                                Radio<bool>(
                                                  value: true,
                                                  groupValue: themeController.isDark.value,
                                                  onChanged: (bool? value) {
                                                    themeController.changeTheme();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                AppText(
                                                  data: "Dark Mode",
                                                  fontSize: AppSize.width(value: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      text: "Appearance",
                    ),
                    ProfileRow(
                      appThemeColor: appThemeColor,
                      iconData: Icons.contact_mail,
                      onTap: () => Get.toNamed(AppRoutes.contactUsScreen),
                      text: "Contact Us",
                    ),
                    ProfileRow(
                      appThemeColor: appThemeColor,
                      iconData: Icons.article,
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.termsAndConditionScreen,
                          arguments: 'terms-and-conditions',
                        );
                      },
                      text: "Terms & Conditions",
                    ),
                    ProfileRow(
                      appThemeColor: appThemeColor,
                      iconData: Icons.policy,
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.termsAndConditionScreen,
                          arguments: 'privacy-policy',
                        );
                      },
                      text: "Privacy Policy",
                    ),
                    ProfileRow(
                      appThemeColor: appThemeColor,
                      iconData: Icons.policy,
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.termsAndConditionScreen,
                          arguments: 'user-manual',
                        );
                      },
                      text: "User Manual",
                    ),
                    ProfileRow(
                      appThemeColor: appThemeColor,
                      iconData: Icons.delete,
                      text: "Delete Account",
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ShowCustomDialog(
                              backgroundColor: appThemeColor.text1,
                              title: 'Want to delete account !',
                              titleStyle: TextStyle(color: appThemeColor.text2),
                              description: 'Please confirm your password to remove your account.',
                              descriptionStyle: TextStyle(color: appThemeColor.text2),
                              actionsLayout: ActionsLayout.column,
                              image: Image.asset(
                                AppImagePath.deleteBox,
                                color: appThemeColor.text2,
                              ),
                              actions: [
                                Form(
                                  key: profileController.formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        fontFamily: GoogleFonts.outfit().fontFamily,
                                        text: 'Password',
                                        fontColor: appThemeColor.text2,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        textAlignment: TextAlign.start,
                                      ),
                                      TextFieldWidget(
                                        height: 44,
                                        borderRadius: 8,
                                        validator: profileController.validatePassword,
                                        controller: profileController.passwordTEController,
                                        hintText: 'password',
                                      ),
                                      SizedBox(height: AppSize.height(value: 12)),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Obx(() {
                                              final isLoading = profileController.isLoading.value;
                                              return GestureDetector(
                                                onTap: isLoading ? null : Get.back,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: AppSize.width(value: 18),
                                                    vertical: AppSize.width(value: 14),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(color: appThemeColor.stroke),
                                                  ),
                                                  child: Center(
                                                    child: AppText(
                                                      fontFamily: GoogleFonts.outfit().fontFamily,
                                                      data: "Cancel",
                                                      fontSize: AppSize.width(value: 16),
                                                      fontWeight: FontWeight.w500,
                                                      color: appThemeColor.text2,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                          SizedBox(width: AppSize.width(value: 8)),
                                          Expanded(
                                            child: Obx(() {
                                              return AppButton(
                                                titleColor: appThemeColor.text1,
                                                filColor: appThemeColor.stroke,
                                                title: profileController.isLoading.value == true
                                                    ? "Please wait..."
                                                    : "Delete",
                                                onTap: () => profileController.onTapDeleteAccountButton(),
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    ProfileRow(
                      appThemeColor: appThemeColor,
                      iconData: Icons.exit_to_app,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ShowCustomDialog(
                              backgroundColor: appThemeColor.text1,
                              image: Image.asset(
                                AppImagePath.logoutImage,
                                color: appThemeColor.stroke,
                              ),
                              actionsLayout: ActionsLayout.row,
                              title: 'Do you want to log out of your profile?',
                              titleStyle: TextStyle(color: appThemeColor.text2),
                              actions: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: Get.back,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: AppSize.width(value: 18),
                                            vertical: AppSize.width(value: 14),
                                          ),
                                          decoration: BoxDecoration(
                                            color: appThemeColor.textPrimary,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: appThemeColor.stroke),
                                          ),
                                          child: Center(
                                            child: AppText(
                                              data: "Cancel",
                                              fontSize: AppSize.width(value: 16),
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: AppSize.width(value: 8)),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          profileController.logout();
                                        },
                                        child: AppButton(
                                          filColor: appThemeColor.button,
                                          title: "Log Out",
                                          titleColor: appThemeColor.text1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      text: "Log Out",
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final IconData? iconData;
  final String? imagePath;
  final String? text;
  final VoidCallback? onTap;
  final AppThemeColor appThemeColor;

  const ProfileRow({
    super.key,
    required this.appThemeColor,
    this.iconData,
    this.imagePath,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                imagePath!,
                width: AppSize.width(value: 24),
                height: AppSize.width(value: 24),
                fit: BoxFit.cover,
              ),
            )
          else if (iconData != null)
            Icon(
              iconData,
              color: appThemeColor.button,
              size: AppSize.width(value: 24),
            ),
          SizedBox(width: AppSize.width(value: 10)),
          AppText(
            data: text ?? "",
            fontWeight: FontWeight.w500,
            color: appThemeColor.text2,
            fontSize: AppSize.width(value: 14),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: appThemeColor.button,
            size: AppSize.width(value: 16),
          ),
        ],
      ),
    );
  }
}

