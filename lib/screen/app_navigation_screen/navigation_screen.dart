import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/constant/app_image_path.dart';
import '../../constant/app_color/app_theme_color.dart';
import '../../widget/app_image/app_image.dart';
import '../customer_details_screen/customer_details_screen.dart';
import '../home_screen/home_screen.dart';
import '../profile_section/profile_screen/profile_screen.dart';
import '../sales_management_screen/sales_management_screen.dart';
import 'controller/navigation_screen_controller.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor color = Theme.of(context).extension<AppThemeColor>()!;

    // Responsive variables
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(
      context,
    ).padding.bottom; // Device safe area
    final isTablet = screenWidth > 600;
    final isSmallPhone = screenWidth < 360;

    return GetBuilder(
      init: NavigationScreenController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(
            () => IndexedStack(
              index: controller.selectedIndex.value,
              children: [
                HomeScreen(),
                SalesManagementScreen(),
                CustomerTableScreen(),
                ProfileScreen(),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            // Dynamic height with safe area consideration
            height:
                _getNavBarHeight(screenHeight, isTablet, isSmallPhone) +
                bottomPadding,
            padding: EdgeInsets.only(
              bottom: bottomPadding + 4, // Include device safe area
              top: _getTopPadding(screenHeight, isTablet),
              left: _getHorizontalPadding(screenWidth),
              right: _getHorizontalPadding(screenWidth),
            ),
            decoration: BoxDecoration(
              color: color.surfacePrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.text2.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isSelected = controller.selectedIndex.value == index;
                  final iconPaths = [
                    AppImagePath.homeNavImage,
                    AppImagePath.sellNavImage,
                    AppImagePath.customerDetailsNavImage,
                    AppImagePath.profileNavImage,
                  ];

                  return Expanded(
                    child: InkWell(
                      onTap: () => controller.changeIndex(index),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: _getItemVerticalPadding(
                            screenHeight,
                            isTablet,
                          ),
                          horizontal: _getItemHorizontalPadding(screenWidth),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon
                            AppImage(
                              path: iconPaths[index],
                              width: _getIconSize(screenWidth, isTablet),
                              height: _getIconSize(screenWidth, isTablet),
                              iconColor: isSelected ? color.icon : color.text2,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              height: _getSpacing(screenHeight, isTablet),
                            ),
                            // Text
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _getTabTitle(
                                    index,
                                    isSmallScreen: isSmallPhone,
                                  ),
                                  style: TextStyle(
                                    fontSize: _getFontSize(
                                      screenWidth,
                                      isTablet,
                                    ),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? color.icon
                                        : color.text2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            // Indicator
                            SizedBox(
                              height: 4, // Fixed space for indicator
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(top: 1),
                                height: isSelected ? 2 : 0,
                                width: isSelected
                                    ? _getIndicatorWidth(
                                        _getTabTitle(
                                          index,
                                          isSmallScreen: isSmallPhone,
                                        ),
                                        screenWidth,
                                      )
                                    : 0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: isSelected
                                      ? color.icon
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  // Responsive calculations
  double _getNavBarHeight(
    double screenHeight,
    bool isTablet,
    bool isSmallPhone,
  ) {
    if (isTablet) return 100.0;
    if (isSmallPhone) return 70.0;
    if (screenHeight < 600) return 75.0;
    if (screenHeight < 700) return 80.0;
    return 85.0;
  }

  double _getTopPadding(double screenHeight, bool isTablet) {
    if (isTablet) return 12.0;
    if (screenHeight < 600) return 8.0;
    return 10.0;
  }

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth < 360) return 4.0;
    if (screenWidth > 600) return 16.0;
    return 8.0;
  }

  double _getItemVerticalPadding(double screenHeight, bool isTablet) {
    if (isTablet) return 4.0;
    if (screenHeight < 600) return 2.0;
    return 3.0;
  }

  double _getItemHorizontalPadding(double screenWidth) {
    if (screenWidth < 360) return 2.0;
    return 4.0;
  }

  double _getIconSize(double screenWidth, bool isTablet) {
    if (isTablet) return 26.0;
    if (screenWidth < 360) return 18.0;
    if (screenWidth < 400) return 20.0;
    return 22.0;
  }

  double _getSpacing(double screenHeight, bool isTablet) {
    if (isTablet) return 4.0;
    if (screenHeight < 600) return 2.0;
    return 3.0;
  }

  double _getFontSize(double screenWidth, bool isTablet) {
    if (isTablet) return 12.0;
    if (screenWidth < 360) return 9.0;
    if (screenWidth < 400) return 10.0;
    return 11.0;
  }

  double _getIndicatorWidth(String text, double screenWidth) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: _getFontSize(screenWidth, screenWidth > 600),
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.size.width.clamp(20.0, screenWidth / 5);
  }

  String _getTabTitle(int index, {bool isSmallScreen = false}) {
    if (isSmallScreen) {
      const shortTitles = ['Home', 'Sale', 'Client', 'Profile'];
      return shortTitles[index];
    }
    const titles = ['Home', 'Sales', 'Customers', 'Profile'];
    return titles[index];
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.size.width;
  }
}
