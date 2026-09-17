import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import 'package:merchent/widget/app_snack_bar/app_snack_bar.dart';
import 'package:merchent/widget/appbar_widget/appbar_widget.dart';
import 'package:merchent/widget/text_field_widget/text_field_widget.dart';
import '../../../constant/app_color/app_color.dart';
import '../../../constant/app_color/app_theme_color.dart';
import '../../../constant/app_image_path.dart';
import '../../../utils/app_size.dart';
import '../../../widget/app_button/app_button.dart';
import '../../../widget/app_image/app_image_circular.dart';
import '../../../widget/app_log/app_print.dart';
import 'change_profile_controller/change_profile_controller.dart';

class ChnageProfileScreen extends StatefulWidget {
  const ChnageProfileScreen({super.key});

  @override
  State<ChnageProfileScreen> createState() => _ChnageProfileScreenState();
}

class _ChnageProfileScreenState extends State<ChnageProfileScreen> {
  late final ChangeProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChangeProfileController());
    controller.prepareCscPickerForRoute();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.onAppInitialDataLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
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
          text: "Change Profile Information",
          fontSize: 18,
          fontWeight: FontWeight.w700,
          textAlignment: TextAlign.center,
          fontColor: appThemeColor.text2,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Obx(() {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child:
                          controller.isLocalImage.value &&
                              controller.profileImage.value != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(
                                controller.profileImage.value!,
                              ),
                            )
                          : controller.profileImageUrl.value.isNotEmpty
                          ? ClipOval(
                              child: AppImageCircular(
                                borderRadius: 100,
                                height: 120,
                                width: 120,
                                url: controller.profileImageUrl.value,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const AppImageCircular(
                              borderRadius: 100,
                              height: 120,
                              width: 120,
                              url: AppImagePath.profile,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          // Show bottom sheet for image selection
                          Get.bottomSheet(
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.photo_library,
                                      color: appThemeColor.text4,
                                    ),
                                    title: TextWidget(
                                      textAlignment: TextAlign.start,
                                      text: 'Choose from Gallery',
                                      fontColor: appThemeColor.text4,
                                    ),
                                    onTap: () {
                                      controller.pickImage(fromCamera: false);
                                      Get.back();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.camera_alt,
                                      color: appThemeColor.text4,
                                    ),
                                    title: TextWidget(
                                      textAlignment: TextAlign.start,
                                      text: 'Take a Photo',
                                      fontColor: appThemeColor.text4,
                                    ),
                                    onTap: () {
                                      controller.pickImage(fromCamera: true);
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.fromBorderSide(
                              BorderSide(color: Colors.green, width: 1.5),
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSize.size.height * 0.01,
                  children: [
                    TextWidget(text: 'Full Name', fontWeight: FontWeight.w500),
                    TextFieldWidget(
                      borderRadius: 8,
                      height: 54,
                      validator: controller.validateName,
                      controller: controller.fullName,
                      hintText: "Enter Name",
                    ),

                    TextWidget(
                      text: 'Phone Number',
                      fontWeight: FontWeight.w500,
                    ),
                    TextFieldWidget(
                      onTap: () {
                        AppSnackBar.message('Number is not editable');
                      },
                      readOnly: true,
                      borderRadius: 8,
                      height: 54,
                      // validator: controller.validatePhone,
                      controller: controller.phoneNumber,
                      hintText: "Enter Number",
                    ),

                    TextWidget(text: 'Email', fontWeight: FontWeight.w500),
                    TextFieldWidget(
                      onTap: () {
                        AppSnackBar.message('Email is not editable');
                      },
                      readOnly: true,
                      borderRadius: 8,
                      height: 54,
                      // validator: controller.validateEmail,
                      controller: controller.emailController,
                      hintText: "Enter Email",
                    ),

                    TextWidget(text: 'Address', fontWeight: FontWeight.w500),

                    Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldWidget(
                            controller: controller.addressController,
                            hintText: "Enter Address",
                            onChanged: controller.onAddressChanged,
                            height: 50,
                            borderRadius: 8,

                            customSuffixIcon:
                                controller.addressController.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      controller.addressController.clear();
                                      controller.onAddressChanged('');
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          if (controller.isFetchingSuggestion.value)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Searching address...'),
                                ],
                              ),
                            ),
                          if (controller.locationSuggestions.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F7F7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: controller.locationSuggestions
                                    .map(
                                      (suggestion) => ListTile(
                                        leading: const Icon(
                                          Icons.location_pin,
                                          color: Colors.green,
                                        ),
                                        title: Text(suggestion.address , style: TextStyle(color: Colors.black),),
                                        subtitle: Text(
                                          'Lat: ${suggestion.latitude.toStringAsFixed(4)}, Lng: ${suggestion.longitude.toStringAsFixed(4)}',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onTap: () => controller
                                            .onSuggestionSelected(suggestion),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                        ],
                      );
                    }),
                    TextWidget(
                      text: 'Country & State',
                      fontWeight: FontWeight.w500,
                    ),
                    Obx(() {
                      if (!controller.isCscPickerDataReady.value) {
                        return SizedBox(
                          height: AppSize.height(value: 120),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      return CSCPickerPlus(
                        key: ValueKey(controller.cscPickerMountId.value),
                        countryDropdownLabel: "Select your country",
                        stateDropdownLabel: "Select your Province",
                        layout: Layout.vertical,
                        showStates: true,
                        showCities: false,
                        countryFilter: const [CscCountry.Pakistan],
                        defaultCountry: CscCountry.Pakistan,
                        disableCountry: true,
                        searchBarRadius: 0,
                        selectedItemStyle: TextStyle(
                          color: appThemeColor.text4,
                          fontSize: 16,
                          height: 2,
                        ),
                        dropdownDecoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        countryStateLanguage:
                            CountryStateLanguage.englishOrNative,
                        currentCountry: controller.selectedCountry.value.isEmpty
                            ? null
                            : controller.selectedCountry.value,
                        currentState: controller.selectedState.value.isEmpty
                            ? null
                            : controller.selectedState.value,
                        onCountryChanged: (country) {
                          controller.onCountrySelected(country);
                          AppPrint.apiResponse("Selected Country: $country");
                        },
                        onStateChanged: (state) {
                          controller.onStateSelected(state);
                          AppPrint.apiResponse(
                            "Selected State/District: $state",
                          );
                        },
                        onCityChanged: (city) {
                          AppPrint.apiResponse("Selected City: $city");
                        },
                      );
                    }),
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
          child: Obx(() {
              return AppButton(
                isLoading: controller.isLoading.value,
                onTap: () => controller.updateProfile(context),
                filColor: appThemeColor.icon,
                titleColor: appThemeColor.text1,
                title: "Save",
                titleSize: AppSize.width(value: 18),
                borderRadius: BorderRadius.circular(AppSize.width(value: 24)),
              );
            }
          ),
        ),
      ),
    );
  }
}
