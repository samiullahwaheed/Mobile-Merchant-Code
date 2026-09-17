import 'package:get/get.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import '../../../../utils/app_log/app_log.dart';
import '../../api_service/api_services.dart';

class ContactUsRepository extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _successfullyMessage = '';
  String get successfullyMessage => _successfullyMessage;

  // Return status code for better handling
  Future<int> contactUsApiCall({required contactUsModel}) async {
    _inProgress = true;
    _errorMessage = '';
    _successfullyMessage = '';
    update(); // Update UI for GetBuilder

    try {
      final response = await ApiService.postApi(
        AppApiEndPoint.instance.contactUs,
        contactUsModel,
      );

      _inProgress = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _successfullyMessage =
            response.message ?? "Contact message submitted successfully";

        appLog('Contact Us submitted successfully');
        update(); // Update UI for GetBuilder
        return response.statusCode;
      } else {
        _errorMessage = response.message ?? "Failed to submit contact message";
        appLog(
          'Contact Us failed - Status: ${response.statusCode}, Message: ${response.message}',
        );
        update(); // Update UI for GetBuilder
        return response.statusCode;
      }
    } catch (e) {
      _inProgress = false;
      _errorMessage = "Network error occurred";
      appLog('Contact Us API Error: $e');
      update(); // Update UI for GetBuilder
      return 500; // Internal error
    }
  }
}
