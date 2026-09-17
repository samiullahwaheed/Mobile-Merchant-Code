import 'dart:io';

import 'package:get/get.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import 'package:merchent/service/api_service/service_model/service_model.dart';
import '../../api_service/api_services.dart';

class ShopInformationUpdateRepository extends GetxController {
  bool _inProgress = false;

  bool get signUpInProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successfullyMessage;
  String? get successfullyMessage => _successfullyMessage;

  Future<ApiResponseModel> sentShopInformationUpdatedData({
    String? businessName,
    String? website,
    String? country,
    String? city,
    String? service,
    String? about,
    File? imageFile,
  }) async {
    Map<String, dynamic> body = {
      'businessName': businessName ?? '',
      'website': website ?? '',
      'country': country ?? '',
      'city': city ?? '',
      'service': service ?? '',
      'about': about ?? '',
    };

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
}
