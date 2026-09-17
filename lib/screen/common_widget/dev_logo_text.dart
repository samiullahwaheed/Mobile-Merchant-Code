import 'package:flutter/material.dart';
import 'package:merchent/widget/app_image/app_image.dart';

class DevLogoText extends StatelessWidget {
  final TextAlign textAlignment;
  final double logoSize;
  const DevLogoText({
    super.key,
    this.textAlignment = TextAlign.center,
    this.logoSize = 100,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenHeight < 700;
    final isMobile = screenWidth < 400;

    return AppImage(
      path: "assets/images/rewaldo-logo-white.png",
      width: 250,
      height: 150,
    );

  }
}
