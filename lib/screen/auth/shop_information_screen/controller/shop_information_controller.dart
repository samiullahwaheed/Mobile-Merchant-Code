import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merchent/service/api_service/service_model/service_model.dart';
import 'package:merchent/service/storage/storage_key.dart';
import 'package:merchent/service/storage/storage_service.dart';
import '../../../../routes/app_routes.dart';
import '../../../../service/repository/auth_repository/shop_information_update_repository.dart';
import '../../../../utils/app_log/error_log.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';

class ShopInformationController extends GetxController {
  final RxString selectedCategory = ''.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isLocalImage = false.obs;
  final RxBool isLoading = false.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final ShopInformationUpdateRepository shopInformationUpdateRepository =
      ShopInformationUpdateRepository();
  final RxString selectedCountry = ''.obs;
  final RxString selectedState = ''.obs;
  final RxString selectedCity = ''.obs;

  static const Map<String, List<String>> countryCityData = {
    "Pakistan": [
      "Islamabad",
      "Rawalpindi",
      "Karachi",
      "Lahore",
      "Peshawar",
      "Quetta",
    ],
  };

  final RxList<String> countries = countryCityData.keys.toList().obs;
  final RxList<String> filteredCities = <String>[].obs;

  final List<String> serviceCategories = [
    "Food and Beverages",
    "Apparel and Footwear",
    "Accessories",
    "Health and Beauty",
    "Salons and Spas",
    "Leisure and Entertainment",
    "Home and Living",
    "Education",
    "Electronics",
    "Toys and Gifts",
    "Travel and Tour",
    "Other Services",
  ];

  Future<void> pickImage({required bool fromCamera}) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        isLocalImage.value = true;
      }
    } catch (e) {
      errorLog("Image picking failed");
      AppSnackBar.error("Failed to select image.");
    }
  }

  void onCountrySelected(String country) {
    selectedCountry.value = country;
    selectedCity.value = '';
    filteredCities.value = countryCityData[country] ?? [];
  }

  void onStateSelected(String? state) {
    final value = state ?? '';
    selectedState.value = value;
    selectedCity.value = value;
  }

  @override
  void onClose() {
    nameController.dispose();
    websiteController.dispose();
    aboutController.dispose();
    super.onClose();
  }

  Future<void> submitCoordinates() async {
    isLoading.value = true;

    ApiResponseModel responseModel = await shopInformationUpdateRepository
        .sentShopInformationUpdatedData(
          businessName: nameController.text,
          website: websiteController.text,
          country: selectedCountry.value,
          city: selectedCity.value,
          service: selectedCategory.value,
          about: aboutController.text,
          imageFile: profileImage.value,
        );
    isLoading.value = false;

    if (responseModel.statusCode == 200) {
      AppSnackBar.success(responseModel.message);
      LocalStorage.setBool(LocalStorageKeys.isBusiness, true);
      Get.toNamed(AppRoutes.locationScreen);
    } else {
      AppSnackBar.error(responseModel.message);
    }
  }
}
