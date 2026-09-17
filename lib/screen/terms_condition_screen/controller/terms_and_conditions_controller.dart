
import 'package:get/get.dart';
import '../../../../constant/content/privacy_policy_content.dart';
import '../../../../constant/content/terms_and_conditions_content.dart';
import '../../../../constant/content/user_manual_content.dart';
import '../../../../service/repository/condition_repository.dart';
import '../../../../utils/app_log/error_log.dart';
import '../model/policy_model.dart';


class TermsAndConditionsController extends GetxController {
  final CommonRepository commonRepository = CommonRepository();
  final args = Get.arguments;

  static const String _privacyPolicyArg = 'privacy-policy';
  static const String _termsAndConditionsArg = 'terms-and-conditions';
  static const String _userManualArg = 'user-manual';

  // Observable for the complete terms and conditions model
  var termsConditions = TermsAndConditionsModel(
    id: '',
    type: '',
    content: '',

  ).obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    // The Privacy Policy is a legal document, so it is always served from
    // the bundled static content rather than the CMS-driven endpoint used
    // for other disclaimers (e.g. Terms & Conditions).
    if (args == _privacyPolicyArg) {
      termsConditions.value = TermsAndConditionsModel(
        id: '',
        type: _privacyPolicyArg,
        content: kPrivacyPolicyHtml,
      );
      errorMessage('');
      return;
    }

    // The Terms & Conditions are a legal document, so they are always
    // served from the bundled static content, matching how the Privacy
    // Policy is handled above.
    if (args == _termsAndConditionsArg) {
      termsConditions.value = TermsAndConditionsModel(
        id: '',
        type: _termsAndConditionsArg,
        content: kTermsAndConditionsHtml,
      );
      errorMessage('');
      return;
    }

    // The User Manual is a bundled reference document, so it is served
    // from static content rather than the CMS-driven endpoint, matching
    // how the Privacy Policy is handled above.
    if (args == _userManualArg) {
      termsConditions.value = TermsAndConditionsModel(
        id: '',
        type: _userManualArg,
        content: kUserManualHtml,
      );
      errorMessage('');
      return;
    }

    try {
      isLoading(true);
      errorMessage('');

      final response = await commonRepository.fetchDisclaimerData(type: args);
      if (response != null) {
        termsConditions.value = response.data;
        errorMessage('');
      } else {
        errorMessage('No content available');
      }
    } catch (e, st) {
      errorLog('loadData $e\n$st', );
      errorMessage('Error loading content: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  // Method to reload data
  void refreshData() {
    loadData();
  }

  // Getter methods for easy access
  String get content => termsConditions.value.content;
  String get type => termsConditions.value.type;
  DateTime? get lastUpdated => termsConditions.value.updatedAt;
}
