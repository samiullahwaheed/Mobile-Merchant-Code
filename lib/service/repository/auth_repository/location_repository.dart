import 'package:get/get.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import '../../api_service/api_services.dart';

class LocationRepository extends GetxController {
  bool _inProgress = false;

  bool get signUpInProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successfullyMessage;
  String? get successfullyMessage => _successfullyMessage;

  Future<bool> sentLocation(Map<String, dynamic> locationModel) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    var response = await ApiService.patchApi(
      AppApiEndPoint.instance.updateProfile,
      body: locationModel,
    );

    if (response.statusCode == 200) {
      _successfullyMessage = response.message;
      isSuccess = true;
    } else {
      _errorMessage = response.message;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
