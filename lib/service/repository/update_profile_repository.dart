import 'dart:convert';
import 'dart:io';

import '../../utils/app_log/app_log.dart';
import '../../utils/app_log/error_log.dart';

import '../../constant/app_api_end_point.dart';
import '../api_service/api_services.dart';
import '../api_service/service_model/service_model.dart';

class UpdateProfileRepository {
  bool _inProgress = false;

  bool get signUpInProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successfullyMessage;
  String? get successfullyMessage => _successfullyMessage;

  Future<ApiResponseModel> sentShopInformationUpdatedData({
    String? firstName,
    // String? phone,
    // String? email,

    String? latitude,
    String? longitude,
    String? address,
    String? city,
    String? country,
    Map<String, dynamic>? location,
    File? imageFile,
  }) async {
    final Map<String, dynamic> body = {
      'firstName': firstName ?? '',
      // 'phone': phone ?? '',
      // 'email': email ?? '',
    };

    if (address != null && address.isNotEmpty) {
      body['address'] = address;
    }
    if (latitude != null && longitude != null) {
      body['latitude'] = latitude;
      body['longitude'] = longitude;
    }

    if (city != null && city.isNotEmpty) {
      body['city'] = city;
    }

    if (country != null && country.isNotEmpty) {
      body['country'] = country;
    }

    if (location != null) {
      body['location'] = jsonEncode(location);
    }

    List<MultipartBody> multipartFiles = [];

    if (imageFile != null) {
      multipartFiles.add(MultipartBody("profile", imageFile));
    }

    ApiResponseModel response = await ApiService.patchMultipartApi(
      AppApiEndPoint.instance.updateProfile,
      body,
      multipartBody: multipartFiles,
    );

    return response;
  }

  Future<void> syncFCMToken(String token) async {
    try {
      final Map<String, dynamic> body = {"fcmToken": token};

      await ApiService.patchApi(
        AppApiEndPoint.instance.pushNotification,
        body: body,
      );
      appLog("FCM Token Synced Success: $token");
    } catch (e) {
      errorLog("FCM Token Sync Error: $e");
    }
  }
}
