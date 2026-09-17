import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/common_widget/common_button_widget.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import 'package:merchent/utils/app_size.dart';
import '../../../constant/app_image_path.dart';
import '../../../widget/auth_top_round_widget.dart';
import 'controller/location_controller.dart';
import 'widget/location_form_widget.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final LocationController controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF3FAE6A), // Green background
        statusBarIconBrightness: Brightness.light, // White icons on Android
        statusBarBrightness: Brightness.dark, // White icons on iOS
      ),
      child: WillPopScope(
        onWillPop: controller.handleBackNavigation,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: GetBuilder<LocationController>(
            builder: (controller) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const TopRoundWidget(hasAppBar: false),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Image.asset(AppImagePath.locationImage),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          const TextWidget(
                            text: 'Find Your Location',
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                          const TextWidget(
                            text:
                                'Please enter your location to get started and help us provide the best services tailored to your area.',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(height: AppSize.height(value: 20)),
                          LocationFormSection(controller: controller),
                          SizedBox(height: AppSize.height(value: 40)),
                          CommonElevatedButton(
                            text: 'Continue',
                            width: double.infinity,
                            onPressed: controller.submitCoordinates,
                            backgroundColor: const Color(0xFF3FAE6A),
                            borderRadius: 100,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
