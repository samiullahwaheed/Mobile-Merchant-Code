import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:merchent/constant/app_api_end_point.dart';

import '../../api_service/api_services.dart';

class DeleteAccountRepository extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successfullyMessage;
  String? get successfullyMessage => _successfullyMessage;

  Future<bool> deleteAccount({required String password}) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    var response = await ApiService.deleteApi(
        url: AppApiEndPoint.instance.deleteAccount,
        body: {
          "password": password
        }
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