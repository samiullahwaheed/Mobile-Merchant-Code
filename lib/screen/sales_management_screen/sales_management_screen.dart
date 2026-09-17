import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import 'package:merchent/screen/sales_management_screen/controller/sales_management_controller.dart';
import 'package:merchent/screen/sales_management_screen/widget/show_custom_bottom_sheet_widget.dart';
import 'package:merchent/screen/home_screen/model/dashboard_model.dart';
import 'package:merchent/service/storage/storage_service.dart';
import 'package:merchent/utils/app_size.dart';
import 'package:merchent/widget/appbar_widget/appbar_widget.dart';
import '../../constant/app_color/app_color.dart';
import '../../constant/app_color/app_theme_color.dart';
import '../../constant/app_image_path.dart';
import '../../routes/app_routes.dart';
import '../home_screen/widget/stat_card.dart';

class SalesManagementScreen extends StatelessWidget {
  final SalesManagementController controller = Get.put(
    SalesManagementController(),
  );

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    return Scaffold(
      appBar: AppbarWidget(
        showLeading: false,
        backgroundColor: appThemeColor.button1,
        textWidget: TextWidget(
          text: 'Sales Management',
          fontColor: appThemeColor.text2,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        action: PopupMenuButton<String>(
          color: appThemeColor.text1,
          onSelected: (value) {
            controller.updateSortOption(value);
          },
          itemBuilder: (BuildContext context) {
            return ['Today', 'Last 7 days', 'Last 30 days', 'All Time'].map((
              String option,
            ) {
              return PopupMenuItem<String>(
                value: option,
                child: Row(
                  children: [
                    Obx(
                      () => Radio<String>(
                        value: option,
                        groupValue: controller.selectedOption.value,
                        onChanged: (String? value) {
                          controller.updateSortOption(value!);
                        },
                      ),
                    ),
                    Text(
                      option,
                      style: TextStyle(
                        color: appThemeColor.text2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          icon: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: ShapeDecoration(
              color: Colors.white, // Text-Secondary
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3000),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 4,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.sort,
                color: AppColor.backgroundColor,
                size: 20,
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Header (if needed)
            // Example: Text("Statistics", style: Theme.of(context).textTheme.headline6)

            // Statistics Cards
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

              return _buildSalesManagementStatsSection(
                appThemeColor: appThemeColor,
                report: report,
                currencyFormatter: currencyFormatter,
                numberFormatter: numberFormatter,
              );
            }),

            SizedBox(height: 60),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  if (LocalStorage.myRole == "ADMIN_MERCHANT" ||
                      LocalStorage.myRole == "MERCHANT")
                    buildContainerMethod(
                      text: "Add New Sell",
                      backgroundColor: appThemeColor.button5,
                      textColor: appThemeColor.text1,
                      function: () => showCustomBottomSheet(context),
                    ),

                  const SizedBox(height: 20),
                  buildContainerMethod(
                    text: "See Full Details",
                    backgroundColor: appThemeColor.cart,
                    textColor: Colors.black,
                    function: () => Get.toNamed(AppRoutes.sellDetailsScreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainerMethod({
    Color? backgroundColor,
    required String text,
    Color? textColor,
    required VoidCallback function,
  }) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: double.infinity,
        // height: 54,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: ShapeDecoration(
          color: backgroundColor ?? const Color(0xFF3FAE6A), // Button color
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFF198248), // Stroke color
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: TextWidget(
          text: text,
          fontColor: textColor ?? Colors.white,
          fontSize: AppSize.width(value: 18),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSalesManagementStatsSection({
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
            Expanded(
              child: StatCard(
                title: 'Total Sales',
                value: currencyFormatter.format(report.totalSales),
                color: appThemeColor.text4,
                borderColor: appThemeColor.text,
                image: Image.asset(AppImagePath.salesImage, height: 22),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
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

String getFormattedDateLabel(String input) {
  switch (input) {
    case 'all':
      return 'All Time';
    case 'today':
      return 'Today';
    case '7d':
      return 'Last 7 Days';
    case '1m':
      return 'Last 30 Days';
    default:
      return '';
  }
}
