import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:merchent/constant/app_color/app_const.dart';
import 'package:merchent/service/storage/storage_key.dart';
import 'package:merchent/service/storage/storage_service.dart';

import '../../../../routes/app_routes.dart';
import '../../../../service/repository/auth_repository/location_repository.dart';
import '../model/location_model.dart';

class LocationController extends GetxController {
  static const String googleApiKey = AppConst.googleMapsApiKey;

  final LocationRepository _locationRepository = Get.put(LocationRepository());

  final TextEditingController inputLocation = TextEditingController();
  Position? currentPosition;
  double? selectedLatitude;
  double? selectedLongitude;
  String? selectedAddress;
  bool isLoadingLocation = false;
  bool isSearchingAddress = false;
  bool isSubmittingLocation = false;

  bool _suppressSearch = false;
  Timer? _debounce;
  final List<LocationSuggestion> _searchResults = [];

  List<LocationSuggestion> get searchResults =>
      List.unmodifiable(_searchResults);
  double? get effectiveLatitude =>
      selectedLatitude ?? currentPosition?.latitude;
  double? get effectiveLongitude =>
      selectedLongitude ?? currentPosition?.longitude;
  String? get mapPreviewUrl {
    final lat = effectiveLatitude;
    final lng = effectiveLongitude;
    if (lat == null || lng == null) return null;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7C$lat,$lng&key=$googleApiKey';
  }

  @override
  void onInit() {
    super.onInit();
    inputLocation.addListener(_onAddressChanged);
  }

  @override
  void onClose() {
    inputLocation.removeListener(_onAddressChanged);
    inputLocation.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  Future<bool> handleBackNavigation() async {
    Get.offAllNamed(AppRoutes.signInScreen);
    return false;
  }

  void clearInputField() {
    inputLocation.clear();
    selectedAddress = null;
    selectedLatitude = null;
    selectedLongitude = null;
    _searchResults.clear();
    update();
  }

  void onSuggestionTap(LocationSuggestion suggestion) {
    _updateAddressField(
      suggestion.address,
      latitude: suggestion.latitude,
      longitude: suggestion.longitude,
    );
  }

  Future<void> useCurrentLocation() async {
    isLoadingLocation = true;
    update();

    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      isLoadingLocation = false;
      update();
      return;
    }

    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (currentPosition != null) {
        final lat = currentPosition!.latitude;
        final lng = currentPosition!.longitude;
        final address = await _reverseGeocode(lat, lng);

        if (address != null && address.isNotEmpty) {
          _updateAddressField(
            address,
            latitude: lat,
            longitude: lng,
          );
        } else {
          final fallback =
              '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';
          _updateAddressField(
            fallback,
            latitude: lat,
            longitude: lng,
          );
          Get.snackbar(
            'Address lookup',
            'Could not resolve a street address. You can edit the location text or try again.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Location Error',
        'Unable to fetch location. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingLocation = false;
      update();
    }
  }

  void goToShopInformation() {
    Get.toNamed(
      AppRoutes.shopInformationScreen,
      arguments: {
        'address': inputLocation.text.trim(),
        'latitude': effectiveLatitude,
        'longitude': effectiveLongitude,
      },
    );
  }

  Future<void> submitCoordinates() async {
    final lat = effectiveLatitude;
    final lng = effectiveLongitude;

    if (lat == null || lng == null) {
      Get.snackbar(
        'Location Required',
        'Please select an address or use your current location before continuing.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmittingLocation = true;
    update();

    final addressForApi = inputLocation.text.trim().isNotEmpty
        ? inputLocation.text.trim()
        : (selectedAddress?.trim().isNotEmpty == true
            ? selectedAddress!.trim()
            : null);

    final Map<String, dynamic> payload = LocationPayload(
      latitude: lat,
      longitude: lng,
      address: addressForApi,
    ).toJson();

    final success = await _locationRepository.sentLocation(payload);

    isSubmittingLocation = false;
    update();

    if (success) {
      Get.snackbar(
        'Location Updated',
        _locationRepository.successfullyMessage ??
            'Your location was submitted successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
      LocalStorage.setBool(LocalStorageKeys.isLocation, true);
      // Get.toNamed(AppRoutes.shopInformationScreen);
      Get.offAllNamed(AppRoutes.userBottomNav);
    } else {
      Get.snackbar(
        'Update Failed',
        _locationRepository.errorMessage ??
            'Unable to submit your location. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _onAddressChanged() {
    if (_suppressSearch) {
      return;
    }

    _debounce?.cancel();
    final query = inputLocation.text.trim();

    if (query.length < 3) {
      _searchResults.clear();
      isSearchingAddress = false;
      update();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchAddressSuggestions(query);
    });

    update();
  }

  Future<bool> _handleLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Disabled',
        'Please enable location services.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Denied',
        'Location permissions are permanently denied. Please enable them from settings.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  Future<String?> _reverseGeocode(double lat, double lng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleApiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final status = data['status'] as String?;
      if (status != null &&
          status != 'OK' &&
          status != 'ZERO_RESULTS') {
        return null;
      }

      final results = data['results'];
      if (results is List && results.isNotEmpty) {
        final first = results.first;
        if (first is Map<String, dynamic>) {
          final formatted = first['formatted_address'];
          if (formatted is String && formatted.isNotEmpty) {
            return formatted;
          }
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<void> _fetchAddressSuggestions(String query) async {
    isSearchingAddress = true;
    update();

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(query)}&key=$googleApiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = (data['results'] as List<dynamic>)
            .map((item) => LocationSuggestion.fromGeocodeResult(item))
            .toList();

        _searchResults
          ..clear()
          ..addAll(results);
        update();
      }
    } catch (_) {
      // Ignore errors; UI already shows progress indicator/snackbar if needed.
    } finally {
      isSearchingAddress = false;
      update();
    }
  }

  void _updateAddressField(
    String address, {
    double? latitude,
    double? longitude,
  }) {
    _suppressSearch = true;
    inputLocation.text = address;
    _suppressSearch = false;

    selectedAddress = address;
    selectedLatitude = latitude;
    selectedLongitude = longitude;
    _searchResults.clear();
    update();
  }
}
