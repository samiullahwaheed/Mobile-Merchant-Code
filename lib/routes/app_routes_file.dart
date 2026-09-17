import 'package:get/get.dart';
import 'package:merchent/screen/auth/create_password_screen/create_password_screen.dart';
import 'package:merchent/screen/auth/location_screen/location_screen.dart';
import 'package:merchent/screen/auth/reset_password_screen/reset_password_screen.dart';
import 'package:merchent/screen/auth/sign_in_screen/sign_in_screen.dart';
import 'package:merchent/screen/auth/sign_up_screen/sign_up_screen.dart';
import 'package:merchent/screen/auth/subscription/subscription_screen.dart';
import 'package:merchent/screen/onboarding_screen/on_boarding_screen_template.dart';
import 'package:merchent/screen/splash_screen/splash_screen.dart';
import '../screen/app_navigation_screen/navigation_screen.dart';
import '../screen/no_internet_screen/no_internet_screen.dart';
import '../screen/auth/all_set_screen.dart';
import '../screen/auth/authentications_screen.dart';
import '../screen/auth/forgot_password/forgot_password_screen.dart';
import '../screen/auth/forgot_verify_otp_screen/forgot_pass_verify_otp_screen.dart';
import '../screen/auth/shop_information_screen/shop_information_screen.dart';
import '../screen/auth/subscription_thanks.dart';
import '../screen/auth/verify_otp_screen/verify_otp_screen.dart';
import '../screen/contact_us_screen/contact_us_screen.dart';
import '../screen/customer_profile_screen/customer_profile_screen.dart';
import '../screen/new_transaction_screen/new_transaction_screen.dart';
import '../screen/notification_screen/notification_screen.dart';
import '../screen/privacy_policy_screen/privacy_policy_screen.dart';
import '../screen/profile_section/chnage_pass_screen/change_pass_screen.dart';
import '../screen/profile_section/chnage_profile_info/chnage_profile_screen.dart';
import '../screen/profile_section/profile_screen/profile_screen.dart';
import '../screen/sell_details_screen/sell_details_screen.dart';
import '../screen/terms_condition_screen/terms_condition_screen.dart';
import '../screen/total_summary_screen/total_summary_screen.dart';
import 'app_routes.dart';

List<GetPage> appRootRoutesFile = <GetPage>[

  GetPage(
    name: AppRoutes.splashScreen,
    // binding: SplashScreenBinding(),
    page: () => SplashScreen(),
  ),

  GetPage(
    name: AppRoutes.profileScreen,
    // binding: SplashScreenBinding(),
    page: () => ProfileScreen(),
  ),

  GetPage(
    name: AppRoutes.onBoardingScreen,
    // binding: SplashScreenBinding(),
    page: () => OnboardingScreen(),
  ),

  GetPage(
    name: AppRoutes.authenticationsScreen,
    // binding: SplashScreenBinding(),
    page: () => AuthenticationsScreen(),
  ),

  GetPage(
    name: AppRoutes.signInScreen,
    // binding: SplashScreenBinding(),
    page: () => SignInScreen(),
  ),

  GetPage(
    name: AppRoutes.signUpScreen,
    // binding: SplashScreenBinding(),
    page: () => SignUpScreen(),
  ),

  GetPage(
    name: AppRoutes.forgotPasswordScreen,
    // binding: SplashScreenBinding(),
    page: () => ForgotPasswordScreen(),
  ),

  GetPage(
    name: AppRoutes.forgotPassVerifyOtpScreen,
    // binding: SplashScreenBinding(),
    page: () => ForgotPassVerifyOtpScreen(),
  ),

  GetPage(
    name: AppRoutes.resetPasswordScreen,
    // binding: SplashScreenBinding(),
    page: () => ResetPasswordScreen(),
  ),

  GetPage(
    name: AppRoutes.createNewPasswordScreen,
    // binding: SplashScreenBinding(),
    page: () => CreateNewPasswordScreen(),
  ),

  GetPage(
    name: AppRoutes.verifyOtpScreen,
    // binding: SplashScreenBinding(),
    page: () => VerifyOtpScreen(),
  ),

  GetPage(
    name: AppRoutes.locationScreen,
    // binding: SplashScreenBinding(),
    page: () => LocationScreen(),
  ),

  GetPage(
    name: AppRoutes.shopInformationScreen,
    // binding: SplashScreenBinding(),
    page: () => ShopInformationScreen(),
  ),

  GetPage(
    name: AppRoutes.subscriptionScreen,
    // binding: SplashScreenBinding(),
    page: () => MySubScreen(),
  ),

  GetPage(
    name: AppRoutes.allSetThanksScreen,
    // binding: SplashScreenBinding(),
    page: () => AllSetThanksScreen(),
  ),

  GetPage(
    name: AppRoutes.termsAndConditionScreen,
    // binding: SplashScreenBinding(),
    page: () => TermAndCondition(),
  ),

  GetPage(
    name: AppRoutes.privacyPolicyScreen,
    // binding: SplashScreenBinding(),
    page: () => PrivacyPolicyScreen(),
  ),

  GetPage(
    name: AppRoutes.userBottomNav,
    // binding: SplashScreenBinding(),
    page: () => NavigationScreen(),
  ),

  GetPage(
    name: AppRoutes.noInternetScreen,
    page: () => const NoInternetScreen(),
  ),

  GetPage(
    name: AppRoutes.changeProfileScreen,
    // binding: SplashScreenBinding(),
    page: () => ChnageProfileScreen(),
  ),

  GetPage(
    name: AppRoutes.changePassScreen,
    // binding: SplashScreenBinding(),
    page: () => ChangePassScreen(),
  ),

  GetPage(
    name: AppRoutes.contactUsScreen,
    // binding: SplashScreenBinding(),
    page: () => ContactUsScreen(),
  ),

  GetPage(
    name: AppRoutes.customerProfilePage,
    // binding: SplashScreenBinding(),
    page: () => CustomerProfilePage(),
  ),

  GetPage(
    name: AppRoutes.newTransaction,
    // binding: SplashScreenBinding(),
    page: () => NewTransaction(),
  ),

  GetPage(
    name: AppRoutes.totalSummaryScreen,
    // binding: SplashScreenBinding(),
    page: () => TotalSummaryScreen(),
  ),

  GetPage(
    name: AppRoutes.notificationScreen,
    // binding: SplashScreenBinding(),
    page: () => NotificationScreen(),
  ),

  GetPage(
    name: AppRoutes.sellDetailsScreen,
    // binding: SplashScreenBinding(),
    page: () => SellDetailsScreen(),
  ),

  GetPage(
    name: AppRoutes.subscriptionThanksScreen,
    // binding: SplashScreenBinding(),
    page: () => SubscriptionThanksScreen(),
  ),
];
