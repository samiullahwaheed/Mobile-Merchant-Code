import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:merchent/constant/app_color/app_const.dart';
import '../../../../service/api_service/service_model/service_model.dart';
import '../../../../service/repository/update_profile_repository.dart';
import '../../../../utils/app_log/error_log.dart';
import '../../../../widget/app_snack_bar/app_snack_bar.dart';

class ChangeProfileController extends GetxController {
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString profileImageUrl = ''.obs;
  final RxBool isLocalImage = false.obs;

  final RxString selectedCountry = ''.obs;
  final RxString selectedState = ''.obs;
  final RxString selectedCity = ''.obs;

  /// `CSCPickerPlus` syncs `currentCountry` / `currentState` only in [initState] (no [didUpdateWidget]).
  /// After [onAppInitialDataLoad] we bump [cscPickerMountId] so the picker remounts with API values.
  final RxInt cscPickerMountId = 0.obs;
  final RxBool isCscPickerDataReady = false.obs;

  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final RxList<LocationSuggestion> locationSuggestions =
      <LocationSuggestion>[].obs;
  final RxBool isFetchingSuggestion = false.obs;
  final RxBool isLoading = false.obs;
  final UpdateProfileRepository _profileRepository = UpdateProfileRepository();

  Timer? _debounce;
  double? _selectedLatitude;
  double? _selectedLongitude;

  void onCountrySelected(String country) {
    selectedCountry.value = country;
    selectedState.value = '';
    selectedCity.value = '';
  }

  void onStateSelected(String? state) {
    final value = state ?? '';
    selectedState.value = value;
    selectedCity.value = value;
  }

  /// Call synchronously when opening Change Profile so a reused controller does not flash stale CSC values.
  void prepareCscPickerForRoute() {
    isCscPickerDataReady.value = false;
  }

  Future<void> onAppInitialDataLoad() async {
    try {
      isCscPickerDataReady.value = false;
      final arguments = Get.arguments ?? {};
      locationSuggestions.clear();

      fullName.text = arguments['name'] ?? '';
      phoneNumber.text = arguments['phone'] ?? '';
      emailController.text = arguments['email'] ?? '';
      addressController.text = arguments['address'] ?? '';

      selectedCountry.value = (arguments['country'] as String?)?.trim() ?? '';
      selectedState.value = (arguments['city'] as String?)?.trim() ?? '';
      selectedCity.value = selectedState.value;

      _selectedLatitude = double.tryParse(
        arguments['latitude']?.toString() ?? '',
      );
      _selectedLongitude = double.tryParse(
        arguments['longitude']?.toString() ?? '',
      );

      if (arguments['profileImage'] != null) {
        if (arguments['profileImage'] is File) {
          profileImage.value = arguments['profileImage'];
          isLocalImage.value = true;
        } else if (arguments['profileImage'] is String) {
          profileImageUrl.value = arguments['profileImage'];
          isLocalImage.value = false;
        }
      }

      cscPickerMountId.value++;
      isCscPickerDataReady.value = true;
    } catch (e) {
      errorLog("onAppInitialDataLoad error: $e");
      isCscPickerDataReady.value = true;
    }
  }

  Map<String, dynamic>? _buildLocationPayload() {
    final latitude = _selectedLatitude;
    final longitude = _selectedLongitude;

    if (latitude == null || longitude == null) {
      return null;
    }

    return {
      'type': 'Point',
      'coordinates': [longitude, latitude],
    };
  }

  void onAddressChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    if (query.trim().length < 3) {
      locationSuggestions.clear();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchSuggestions(query.trim());
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    const apiKey = LocationController.googleApiKey;
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(query)}&key=$apiKey&types=geocode',
    );

    try {
      isFetchingSuggestion.value = true;
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final predictions = (data['predictions'] as List<dynamic>)
            .cast<Map<String, dynamic>>();

        final futures = predictions.take(5).map(_fetchPlaceDetails);
        final results = await Future.wait(futures);
        locationSuggestions.assignAll(
          results.whereType<LocationSuggestion>().toList(),
        );
      } else {
        if (kDebugMode) {
          errorLog('Places autocomplete failed: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        errorLog('Failed to fetch suggestions: $e');
      }
    } finally {
      isFetchingSuggestion.value = false;
    }
  }

  Future<LocationSuggestion?> _fetchPlaceDetails(
    Map<String, dynamic> prediction,
  ) async {
    try {
      final placeId = prediction['place_id'] as String?;
      if (placeId == null) return null;

      const apiKey = LocationController.googleApiKey;
      final detailsUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&fields=formatted_address,geometry',
      );

      final response = await http.get(detailsUrl);

      if (response.statusCode != 200) {
        return null;
      }

      final details = jsonDecode(response.body) as Map<String, dynamic>;
      final result = details['result'] as Map<String, dynamic>?;
      if (result == null) return null;

      final address = result['formatted_address'] as String?;
      final geometry = result['geometry'] as Map<String, dynamic>?;
      final location = geometry?['location'] as Map<String, dynamic>?;

      if (address == null || location == null) {
        return null;
      }

      final lat = (location['lat'] as num?)?.toDouble();
      final lng = (location['lng'] as num?)?.toDouble();

      if (lat == null || lng == null) {
        return null;
      }

      return LocationSuggestion(
        address: address,
        latitude: lat,
        longitude: lng,
      );
    } catch (e) {
      if (kDebugMode) {
        errorLog('Place details fetch failed: $e');
      }
      return null;
    }
  }

  void onSuggestionSelected(LocationSuggestion suggestion) {
    addressController.text = suggestion.address;
    _selectedLatitude = suggestion.latitude;
    _selectedLongitude = suggestion.longitude;
    locationSuggestions.clear();
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

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    fullName.dispose();
    phoneNumber.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }

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

  Future<void> updateProfile(BuildContext context) async {
    if (fullName.text.trim().isEmpty) {
      AppSnackBar.error("Please enter your first name.");
      return;
    }

    isLoading.value = true; // Show loading indicator
    try {
      final Map<String, dynamic>? locationPayload = _buildLocationPayload();

      final ApiResponseModel response = await _profileRepository
          .sentShopInformationUpdatedData(
            firstName: fullName.text.trim(),
            latitude: _selectedLatitude?.toString(),
            longitude: _selectedLongitude?.toString(),
            // phone: phoneNumber.text.trim(),
            // email: emailController.text.trim(),
            address: addressController.text.trim(),
            city: selectedState.value.trim().isEmpty
                ? null
                : selectedState.value.trim(),
            country: selectedCountry.value.trim().isEmpty
                ? null
                : selectedCountry.value.trim(),
            location: locationPayload,
            imageFile: isLocalImage.value ? profileImage.value : null,
          );

      if (response.statusCode == 200) {
        Get.back(result: true);
        AppSnackBar.success(response.message);
      } else {
        AppSnackBar.error(response.message);
      }
    } catch (e) {
      errorLog('Profile update failed: $e');
      AppSnackBar.error('Something went wrong while updating the profile.');
    } finally {
      isLoading.value = false;
    }
  }
}

class LocationSuggestion {
  final String address;
  final double latitude;
  final double longitude;

  LocationSuggestion({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class LocationController {
  static const String googleApiKey = AppConst.googleMapsApiKey;
}
