import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/app_color/app_color.dart';
import 'controller/splash_controller.dart';

/// Invisible bootstrap screen: the native splash screen (configured via
/// flutter_native_splash) stays on top of this the whole time and is only
/// removed once [SplashController] has decided where to navigate, so the
/// user only ever sees one logo screen.
class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});
  final SplashController splashController = Get.put(SplashController());

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) {
        return Scaffold(backgroundColor: AppColor.backgroundColor);
      },
    );
  }
}
