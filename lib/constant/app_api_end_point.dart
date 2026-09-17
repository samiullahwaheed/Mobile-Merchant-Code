import '../widget/app_log/error_log.dart';

class AppApiEndPoint {
  AppApiEndPoint._privateConstructor();
  static final AppApiEndPoint _instance = AppApiEndPoint._privateConstructor();
  static AppApiEndPoint get instance => _instance;

  //app use base
  static final String domain = _getDomain();

  /// ==========================================================
  /// MEDIA / IMAGE URL BUILDER
  /// ==========================================================
  ///
  /// Backend ab images DigitalOcean Spaces par upload karta hai aur DB mein
  /// poora absolute URL save karta hai (https://cdn.rewaldo.com/uploads/...).
  ///
  /// Purane records mein abhi bhi relative path ho sakta hai (/uploads/...).
  ///
  /// Is helper se dono cases sahi chalte hain. Domain aur path ko seedha
  /// string mein jorna band karein, warna absolute URL ke aage domain lag kar
  /// "https://api.rewaldo.comhttps://cdn..." ban jata hai aur image load nahi hoti.
  static String mediaUrl(String? path) {
    if (path == null) return '';

    final value = path.trim();
    if (value.isEmpty) return '';

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    if (value.startsWith('file://') || value.startsWith('data:')) {
      return value;
    }

    if (value.startsWith('/')) {
      return '$domain$value';
    }

    return '$domain/$value';
  }
  final String baseUrl = "$domain/api/v1";
  final String resetToken = "/auth/refresh-token";
  final String refreshToken = "/auth/refresh-token";
  final String user = "/user";
  final String privacyPolicy = "/others/privacy-policy";
  final String termsAndConditions = "/others/terms-and-conditions";
  final String faq = "/others/faq";
  final String staticsdashboard = "/merchant/merchant-dashboard-report";
  final String giftCardApply = "/sell/promotion/request-approval";
  final String checkout = "/sell/checkout";

  ////////////////////// auth_repository
  final String authLogin = "/auth/login";
  final String contactUs = "/contact";
  final String signUpEndPoint = "/user";
  final String updateProfile = "/user";
  final String pushNotification = "/user";
  final String verifyPhoneNumber = "/auth/verify-otp";
  final String forgotPassEndPoint = "/auth/forgot-password";
  final String resetPassword = "/auth/change-password";
  String disclaimer({required String type}) => "/disclaimers/merchant-$type";

  final String profile = "/user/profile";
  final String weeklySellReport = "/merchant/weekly-sell-report";
  final String deleteAccount = "/auth/user-delete-account";
  final String forgotPassword = "/auth/reset-password";
  final String customerChartWeek = "/merchant/customer-chart-week";
  String customerTransactions(String id) => "/sell/transactions/$id";
  String customerTier(String id) => "/merchant-customer/customers/$id/tier";

  /// Find promotion by card code - GET /add-promotion/find?cardCode=XXX
  String findPromotionByCardCode(String cardCode) =>
      "/add-promotion/find?cardCode=$cardCode";
  // /sell/merchant/693a5aed0f871d96eb50b88d
  String sellDetailsEndPoint = "/sell/merchant";
  final String customerDetailsEndPoint = "/sell/customer";
  final String notificationsEndPoint = "/notifications";
  final String notificationsReadEndPoint = "/notifications/read";
}

// Move this function outside the class
String _getDomain() {
  const String envBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.rewaldo.com',
  );
  try {
    return envBaseUrl;
  } catch (e) {
    errorLog("_getDomain", e);
    return envBaseUrl;
  }
}