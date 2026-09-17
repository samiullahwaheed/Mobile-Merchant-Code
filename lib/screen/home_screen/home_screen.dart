import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:merchent/constant/app_image_path.dart';
import 'package:merchent/routes/app_routes.dart';
import 'package:merchent/screen/home_screen/controller/controller.dart';
import 'package:merchent/screen/home_screen/model/dashboard_model.dart';
import 'package:merchent/screen/home_screen/widget/bar_chart.dart';
import 'package:merchent/screen/home_screen/widget/pie_chart.dart';
import 'package:merchent/screen/home_screen/widget/stat_card.dart';
import 'package:merchent/screen/profile_section/profile_screen/controller/profile_controller.dart';
import 'package:merchent/screen/notification_screen/controller/notification_controller.dart';
import 'package:merchent/screen/sales_management_screen/sales_management_screen.dart';

import '../../constant/app_color/app_theme_color.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenController controller = Get.put(HomeScreenController());
  final ProfileController profileController = Get.put(ProfileController());
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    return Scaffold(
      backgroundColor: appThemeColor.surfacePrimary,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: appThemeColor.surfacePrimary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Obx(() {
            final imagePath = profileController.resolveProfileImage(
              profileController.profile.value,
            );
            if (imagePath.startsWith('http')) {
              return CircleAvatar(backgroundImage: NetworkImage(imagePath));
            }
            return CircleAvatar(backgroundImage: AssetImage(imagePath));
          }),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Obx(() {
            final user = profileController.profile.value;

            final businessName = user?.businessName.isNotEmpty == true
                ? user!.businessName
                : (profileController.isLoading.value
                      ? 'Loading...'
                      : 'Business');

            final cityLine = user?.city.isNotEmpty == true
                ? user!.city
                : (profileController.isLoading.value
                      ? 'Fetching location...'
                      : 'City not set');

            final countryLine = user?.country.isNotEmpty == true
                ? user!.country
                : (profileController.isLoading.value ? '' : 'Country not set');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  businessName,
                  style: TextStyle(
                    color: appThemeColor.text2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                if (cityLine.isNotEmpty)
                  Text(
                    "$cityLine, $countryLine",
                    style: TextStyle(color: appThemeColor.text2, fontSize: 12),
                  ),
              ],
            );
          }),
        ),
        actions: [
          Obx(
            () => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.circle_notifications_outlined,
                    size: 30,
                    color: appThemeColor.button2,
                  ),
                  onPressed: () {
                    Get.toNamed(AppRoutes.notificationScreen);
                  },
                ),
                if (notificationController.unreadCount.value > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${notificationController.unreadCount.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Statistics',
                    style: TextStyle(
                      color: appThemeColor.text2,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Obx(
                      () => DropdownButton<String>(
                        borderRadius: BorderRadius.circular(8),
                        value: controller.userFilterType.value,
                        dropdownColor: appThemeColor.text1,
                        underline: const SizedBox(),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: appThemeColor.text2,
                        ),
                        items:
                            ['Today', 'Last 7 days', 'Last 30 days', 'All Time']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        color: appThemeColor.text2,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: controller.changeUserFilterType,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Obx(() {
                if (controller.isMerchantReportLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.merchantReportError.value.isNotEmpty) {
                  return Text(
                    controller.merchantReportError.value,
                    style: TextStyle(color: appThemeColor.text2),
                  );
                }

                final report = controller.merchantReportData.value;
                if (report == null) {
                  return Text(
                    'No merchant report data available',
                    style: TextStyle(color: appThemeColor.text2),
                  );
                }

                final currencyFormatter = NumberFormat.currency(
                  symbol: '',
                  decimalDigits: 2,
                );
                final numberFormatter = NumberFormat.decimalPattern();

                return _buildHomeStatsSection(
                  appThemeColor: appThemeColor,
                  report: report,
                  currencyFormatter: currencyFormatter,
                  numberFormatter: numberFormatter,
                );
              }),
              SizedBox(height: 24),

              // Weekly Sell Pie Chart
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Sell',
                      style: TextStyle(
                        color: appThemeColor.text4,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomPaint(
                      size: Size(double.infinity, 25),
                      painter: ProgressPainter(.15),
                    ),
                    SizedBox(height: 20),

                    Obx(() {
                      if (controller.isWeeklyReportLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.weeklyReportError.value.isNotEmpty) {
                        return Text(
                          controller.weeklyReportError.value,
                          style: TextStyle(color: appThemeColor.text2),
                        );
                      }

                      final data = controller.weeklySellData.value;

                      if (data == null || data.weeklyReport.isEmpty) {
                        return Text(
                          'No weekly sell data available',
                          style: TextStyle(color: appThemeColor.text2),
                        );
                      }

                      final items = data.weeklyReport;

                      return Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: MyPieChart(
                              items: items,
                              colors: controller.pieColors,
                              totalSell: data.totalSell,
                            ),
                          ),
                          SizedBox(width: 40),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(items.length, (index) {
                                final entry = items[index];
                                final color =
                                    controller.pieColors[index %
                                        controller.pieColors.length];
                                return LegendItem(
                                  color: color,
                                  label: entry.day,
                                );
                              }),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Customer Chart Bar Chart
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),

                    BarTouch(appThemeColor: appThemeColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeStatsSection({
    required AppThemeColor appThemeColor,
    required ReportData report,
    required NumberFormat currencyFormatter,
    required NumberFormat numberFormatter,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (report.range.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Range: ${getFormattedDateLabel(report.range)}',
              style: TextStyle(color: appThemeColor.text2, fontSize: 14),
            ),
          ),
        Row(
          children: [
            Flexible(
              child: StatCard(
                title: 'Total Sales',
                value: currencyFormatter.format(report.totalSales),
                color: appThemeColor.text4,
                borderColor: appThemeColor.text,
                image: Image.asset(AppImagePath.salesImage, height: 22),
              ),
            ),
            SizedBox(width: 12),
            Flexible(
              child: StatCard(
                borderColor: appThemeColor.text,
                color: appThemeColor.text4,
                title: 'New Members',
                value: numberFormatter.format(report.totalMembers),
                image: Image.asset(AppImagePath.userImage, height: 22),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                color: appThemeColor.text4,
                borderColor: appThemeColor.text,
                title: 'Points Issued',
                value: numberFormatter.format(report.totalPointsIssued),
                image: Image.asset(AppImagePath.pointsImage, height: 22),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatCard(
                color: appThemeColor.text4,
                borderColor: appThemeColor.text,
                title: 'Points Redeemed',
                value: numberFormatter.format(report.rewardsRedeemed),
                image: Image.asset(AppImagePath.rewardsImage, height: 22),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({Key? key, required this.color, required this.label})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  // Add a final variable to hold the progress value
  final double progress;

  ProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the full-width background line
    drawCustomLine(canvas, size, Colors.grey);
    drawProgressLine(canvas, size, Colors.blue);
  }

  void drawCustomLine(Canvas canvas, Size size, Color color) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double totalWidth = size.width;
    final double straightWidth = totalWidth * 0.35; // first 20%
    final double jumpWidth = totalWidth * 0.65; // next 80%

    final Path path = Path();

    // Start point
    path.moveTo(0, 10);

    // First 20% straight
    path.lineTo(straightWidth, 10);

    // Jump -2 in y
    // path.lineTo(straightWidth + jumpWidth, 8); // 10 - 2 = 8
    path.lineTo(straightWidth + 10, -2);
    path.lineTo(straightWidth + jumpWidth, -2);

    canvas.drawPath(path, paint);
  }

  void drawProgressLine(Canvas canvas, Size size, Color color) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double totalWidth = size.width * progress;
    final double straightWidth = totalWidth * 0.35; // first 20%
    final double jumpWidth = totalWidth * 0.65; // next 80%

    final Path path = Path();

    // Start point
    path.moveTo(0, 10);

    // First 20% straight
    path.lineTo(straightWidth * 2, 10);

    // Jump -2 in y
    // path.lineTo(straightWidth + jumpWidth, 8); // 10 - 2 = 8
    if ((size.width * .35) < totalWidth) {
      path.lineTo((straightWidth * 2) + 10, -2);
      path.lineTo((straightWidth * 2) + jumpWidth, -2);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ProgressPainter oldDelegate) {
    // Only repaint if the progress value has changed
    return oldDelegate.progress != progress;
  }
}
