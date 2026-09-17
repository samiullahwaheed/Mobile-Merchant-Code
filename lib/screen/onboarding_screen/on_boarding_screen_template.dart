import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/constant/app_image_path.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import 'package:merchent/utils/app_size.dart';
import '../../constant/app_color/app_color.dart';
import '../../routes/app_routes.dart';
import '../common_widget/common_button_widget.dart';

import 'package:merchent/widget/auth_top_round_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingPages = [
    {
      "imagePath": AppImagePath.onboardingCoinImage1,
      "imageWidth": AppSize.width(value: 330),
      "imageHeight": AppSize.width(value: 220),
      "title": 'Welcome To Rewaldo!',
      "subtitle":
          "Every purchase brings your customers closer to exclusive benefits.",
    },
    {
      "imagePath": AppImagePath.onboardingCoinImage2,
      "imageWidth": AppSize.width(value: 243),
      "imageHeight": AppSize.width(value: 220),
      "title": 'Grow with every purchase!',
      "subtitle":
          "Get started today and unlock exclusive be1nefits for your customers.",
    },
    {
      "imagePath": AppImagePath.onboardingStoreImage,
      "imageWidth": AppSize.width(value: 222),
      "imageHeight": AppSize.height(value: 240),
      "imageTopMargin": AppSize.height(value: 200),
      "title": 'Greetings Store Owner!',
      "subtitle":
          "Set up your shop and start offering exclusive benefits to your customers.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Background
          /// Background
          const TopRoundWidget(),

          /// Main Content
          SafeArea(
            child: Column(
              children: [
                /// Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    // vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _currentPage > 0
                          ? GestureDetector(
                              onTap: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 24,
                              ),
                            )
                          : const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          
                          
                          Get.offAllNamed(AppRoutes.authenticationsScreen);
                        },
                        child: const TextWidget(
                          text: 'Skip',
                          // style: TextStyle(
                          //   color: Colors.white,
                          //   fontSize: 16,
                          //   fontWeight: FontWeight.w500,
                          // ),
                          fontColor: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                /// PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingPages.length,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      final page = onboardingPages[index];
                      return buildOnboardingPage(
                        imagePath: page["imagePath"],
                        imageWidth: page["imageWidth"].toDouble(),
                        imageHeight: page["imageHeight"].toDouble(),
                        title: page["title"],
                        subtitle: page["subtitle"],
                      );
                    },
                  ),
                ),

                /// Bottom section
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      /// Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingPages.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: _buildIndicator(index),
                          ),
                        ),
                      ),

                      const Spacer(),

                      /// Next button
                      CommonElevatedButton(
                        text: _currentPage == onboardingPages.length - 1
                            ? "Get Started"
                            : "Next",
                        backgroundColor: AppColor.backgroundColor,
                        onPressed: () {
                          if (_currentPage < onboardingPages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Get.offAllNamed(AppRoutes.authenticationsScreen);
                          }
                        },
                        height: 48,
                        borderRadius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Indicator
  Widget _buildIndicator(int index) {
    return Container(
      width: index == _currentPage ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: index == _currentPage
            ? AppColor.backgroundColor
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// Onboarding page builder
  Widget buildOnboardingPage({
    required String imagePath,
    required String title,
    required String subtitle,
    double imageHeight = 220,
    double imageWidth = double.infinity,
    double? imageTopMargin, // nullable
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 30)),
      child: Column(
        children: [
          SizedBox(height: imageTopMargin),
          Image.asset(
            imagePath,
            width: AppSize.width(value: imageWidth),
            height: AppSize.height(value: imageHeight),
            fit: BoxFit.cover,
          ),
          SizedBox(height: AppSize.height(value: 100)),
          TextWidget(
            text: title,
            textAlignment: TextAlign.center,
            fontSize: AppSize.width(value: 30),
            fontWeight: FontWeight.bold,
            fontColor: Colors.black87,
          ),

          const SizedBox(height: 16),

          TextWidget(
            text: subtitle,
            textAlignment: TextAlign.center,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontColor: Colors.black,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
