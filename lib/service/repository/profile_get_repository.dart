import 'dart:developer';
import 'package:merchent/service/api_service/api_services.dart';
import 'package:merchent/service/storage/storage_key.dart';
import 'package:merchent/service/storage/storage_service.dart';

import '../../constant/app_api_end_point.dart';
import '../../screen/profile_section/profile_screen/model/profile_model.dart';

class ProfileRepository {
  Future<UserProfile> fetchProfile() async {
    try {
      final response = await ApiService.getApi(AppApiEndPoint.instance.profile);

      log('Profile API Response Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception("Failed to load profile");
      }

      final body = response.body;
      log('Profile API Response Body: $body');

      if (body is! Map<String, dynamic>) {
        throw Exception("Invalid profile response format");
      }

      final data = body["data"];
      log('Profile data from response: $data');

      if (body["success"] != true || data is! Map<String, dynamic>) {
        throw Exception("Failed to load profile");
      }

      final userProfile = UserProfile.fromJson(data);
      log('Parsed UserProfile - profile field: "${userProfile.profile}"');

      if (userProfile.location?.coordinates != null ||
          userProfile.location?.coordinates[1] != null ||
          userProfile.location?.coordinates[0] != null) {
        LocalStorage.setBool(LocalStorageKeys.isLocation, true);
      }
      if (userProfile.businessName != null ||
          userProfile.businessName.isNotEmpty) {
        LocalStorage.setBool(LocalStorageKeys.isBusiness, true);
      }

      return userProfile;
    } catch (e) {
      log('Error in ProfileRepository.fetchProfile: $e');
      rethrow;
    }
  }
}
