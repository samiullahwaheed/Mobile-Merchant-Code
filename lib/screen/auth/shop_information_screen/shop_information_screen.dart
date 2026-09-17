import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/auth/shop_information_screen/controller/shop_information_controller.dart';
import 'package:merchent/widget/appbar_widget/appbar_widget.dart';
import '../../../utils/app_size.dart';
import '../../../widget/text_field_widget/text_field_widget.dart';
import '../../common_widget/common_button_widget.dart';
import '../../common_widget/common_text_widget.dart';
import '../sign_up_screen/widget/dropdown_widget.dart';

class ShopInformationScreen extends StatelessWidget {
  final ShopInformationController shopInformationController = Get.put(
    ShopInformationController(),
  );

  ShopInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF3FAE6A), // Green background
        statusBarIconBrightness: Brightness.light, // White icons on Android
        statusBarBrightness: Brightness.dark, // White icons on iOS
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const AppbarWidget(
          textWidget: TextWidget(
            text: 'Shop Information',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      text: 'Enter your Shop Information',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                    SizedBox(height: AppSize.height(value: 20)),
                    const TextWidget(
                      text:
                          'Provide your shop details to get started and make your store ready for customers.',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      textAlignment: TextAlign.start,
                    ),
                    SizedBox(height: AppSize.height(value: 20)),
                    const TextWidget(
                      text: 'Upload Your Company Logo',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    SizedBox(height: AppSize.height(value: 20)),
                    Obx(() {
                      final imageFile =
                          shopInformationController.profileImage.value;

                      return GestureDetector(
                        onTap: () {
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
                                    leading: const Icon(
                                      Icons.photo_library,
                                      color: Color(0xFF198248),
                                    ),
                                    title: const TextWidget(
                                      textAlignment: TextAlign.start,
                                      text: 'Choose from Gallery',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontColor: Color(0xFF198248),
                                      // ),
                                    ),
                                    onTap: () {
                                      shopInformationController.pickImage(
                                        fromCamera: false,
                                      );
                                      Get.back();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.camera_alt,
                                      color: Color(0xFF198248),
                                    ),
                                    title: const TextWidget(
                                      textAlignment: TextAlign.start,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      text: 'Take a Photo',
                                      fontColor: Color(0xFF198248),
                                    ),
                                    onTap: () {
                                      shopInformationController.pickImage(
                                        fromCamera: true,
                                      );
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
                          width: 70,
                          height: 70,
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.fromBorderSide(
                              BorderSide(color: Colors.black, width: 1.5),
                            ),
                          ),
                          child: imageFile != null
                              ? ClipOval(
                                  child: Image.file(
                                    imageFile,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.black,
                                  size: 30,
                                ),
                        ),
                      );
                    }),
                    SizedBox(height: AppSize.height(value: 20)),
                    buildForm(context),
                    SizedBox(height: AppSize.height(value: 20)),
                    Obx(
                      () => CommonElevatedButton(
                        text: shopInformationController.isLoading.value
                            ? 'Please wait...'
                            : 'Continue',
                        width: double.infinity,
                        onPressed: () {
                          shopInformationController.submitCoordinates();
                        },
                        backgroundColor: const Color(0xFF3FAE6A),
                        borderRadius: 100,
                      ),
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

  Widget buildForm(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: AppSize.height(value: 20)),
          TextFieldWidget(
            height: AppSize.height(value: 54),
            borderColor: Colors.black,
            controller: shopInformationController.nameController,
            hintText: 'Enter Business Name',
            hintColor: Colors.black,
          ),
          SizedBox(height: AppSize.height(value: 20)),
          TextFieldWidget(
            height: AppSize.height(value: 54),
            hintColor: Colors.black,
            borderColor: Colors.black,
            controller: shopInformationController.websiteController,
            hintText: 'Enter Website URL',
          ),
          SizedBox(height: AppSize.height(value: 20)),
          Obx(
            () => CustomDropdown<String>(
              dropdownColor: Colors.white,
              items: shopInformationController.countries,
              selectedValue:
                  shopInformationController.countries.contains(
                    shopInformationController.selectedCountry.value,
                  )
                  ? shopInformationController.selectedCountry.value
                  : null,
              hint: "Select your country",
              onChanged: (value) =>
                  shopInformationController.onCountrySelected(value ?? ''),
              borderRadius: 30,
              borderColor: Colors.black,
            ),
          ),
          SizedBox(height: AppSize.height(value: 20)),
          Obx(
            () => CustomDropdown<String>(
              dropdownColor: Colors.white,
              fillColor: Colors.white,
              itemTextColor: Colors.black,
              items: shopInformationController.filteredCities,
              selectedValue:
                  shopInformationController.filteredCities.contains(
                    shopInformationController.selectedCity.value,
                  )
                  ? shopInformationController.selectedCity.value
                  : null,
              hint: "Select your City",
              onChanged: (value) =>
                  shopInformationController.selectedCity.value = value ?? '',
              borderRadius: 30,
              borderColor: Colors.black,
            ),
          ),

          SizedBox(height: AppSize.height(value: 20)),
          Obx(
            () => CustomDropdown<String>(
              dropdownColor: Colors.white,
              fillColor: Colors.white,
              itemTextColor: Colors.black,
              items: shopInformationController.serviceCategories,
              selectedValue:
                  shopInformationController.selectedCategory.value.isEmpty
                  ? null
                  : shopInformationController.selectedCategory.value,
              hint: 'Select Your Service',
              borderColor: const Color(0xFF3FAE6A),
              borderRadius: 100,
              onChanged: (value) =>
                  shopInformationController.selectedCategory.value =
                      value ?? '',
            ),
          ),
          SizedBox(height: AppSize.height(value: 20)),
          TextFieldWidget(
            controller: shopInformationController.aboutController,
            hintText: 'Write About Us',
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
