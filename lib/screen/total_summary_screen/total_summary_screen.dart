import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/widget/appbar_widget/appbar_widget.dart';
import 'package:merchent/widget/showCustomDialog.dart';
import '../../constant/app_color/app_theme_color.dart';
import '../../routes/app_routes.dart';
import '../common_widget/common_button_widget.dart';
import '../common_widget/common_text_widget.dart';
import 'controller/total_summary_controller.dart';

class TotalSummaryScreen extends StatelessWidget {
  TotalSummaryScreen({super.key});

  final TotalSummaryController controller = Get.put(TotalSummaryController());

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    // Get arguments from Get.arguments
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final double totalBill = (args['totalBill'] ?? 0).toDouble();
    final List<String> promotionIds = List<String>.from(
      args['promotionIds'] ?? [],
    );
    final double discountedBill = (args['totalDiscount'] ?? 0).toDouble();
    final double pointRedeemed = (args['pointRedeemed'] ?? 0).toDouble();
    final double pointDiscount = (args['pointDiscount'] ?? 0).toDouble();
    final double finalBill = (args['finalBill'] ?? 0).toDouble();
    final double pointsEarned = (args['pointsEarned'] ?? 0).toDouble();
    final double discountPercentage = (args['discountPercentage'] ?? 0)
        .toDouble();

    return Scaffold(
      backgroundColor: appThemeColor.surfacePrimary,
      appBar: AppbarWidget(
        backgroundColor: appThemeColor.button1,
        textWidget: TextWidget(
          text: 'Summary',
          fontWeight: FontWeight.w700,
          fontSize: 18,
          fontColor: appThemeColor.text2,
          textAlignment: TextAlign.start,
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new, color: appThemeColor.text2),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Card(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Text(
                      'Total Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D5C),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Total Bill Row
                    _buildSummaryRow(
                      'Total Bill:',
                      totalBill.toStringAsFixed(2),
                      false,
                    ),
                    const SizedBox(height: 12),

                    // Points Redeem Row
                    _buildSummaryRow(
                      'Point\'s Redeemed:',
                      '${pointRedeemed.toStringAsFixed(0)} pts',
                      false,
                    ),
                    const SizedBox(height: 12),

                    // Points Earned Row
                    _buildSummaryRow(
                      'Point\'s Earned:',
                      '+${pointsEarned.toStringAsFixed(0)} pts',
                      false,
                    ),

                    const SizedBox(height: 12),

                    _buildSummaryRow(
                      'Promotion Discount:',
                      discountedBill.toStringAsFixed(2),
                      false,
                    ),
                    const SizedBox(height: 16),

                    
                    Container(height: 1, color: Colors.grey.withOpacity(0.2)),
                    const SizedBox(height: 16),

                    // Final Amount Row
                    _buildSummaryRow(
                      'Final Amount:',
                      finalBill.toStringAsFixed(2),
                      true,
                    ),
                    const SizedBox(height: 12),

                    // Effective Discount Row
                    if (totalBill > 0)
                      _buildSummaryRow(
                        'Effective Discount%',
                        '${((discountedBill / totalBill) * 100).toStringAsFixed(2)}%',
                        false,
                      ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 100),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Obx(
                  () => controller.isLoading.value
                      ? SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: appThemeColor.button,
                            ),
                          ),
                        )
                      : CommonElevatedButton(
                          text: 'Complete Transaction',
                          width: double.infinity,
                          textStyle: TextStyle(
                            color: appThemeColor.text1,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          onPressed: () async {
                            // Call checkout API
                            await controller.checkout(
                              promotionId: promotionIds,
                            );

                            // Show dialog with API response
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (dialogContext) {
                                  return Obx(
                                    () => ShowCustomDialog(
                                      title: controller.isSuccess.value
                                          ? 'Success!'
                                          : 'Waiting for approval!',
                                      description:
                                          controller
                                              .responseMessage
                                              .value
                                              .isNotEmpty
                                          ? controller.responseMessage.value
                                          : 'Awaiting customer approval for the transaction.',
                                      descriptionStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      icon: controller.isSuccess.value
                                          ? Icons.check_circle
                                          : Icons.autorenew,
                                      actionsLayout: ActionsLayout.column,
                                      actions: [
                                        CommonElevatedButton(
                                          text: controller.isSuccess.value
                                              ? 'Done'
                                              : 'Close',
                                          textStyle: TextStyle(
                                            color: appThemeColor.text2,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                          onPressed: () {
                                            if (controller.isSuccess.value) {
                                              // Success: Navigate to sellDetailsScreen
                                              Navigator.of(dialogContext).pop();
                                              Get.toNamed(
                                                AppRoutes.sellDetailsScreen,
                                              );
                                            } else {
                                              // Failure: Just pop the dialog
                                              Navigator.of(dialogContext).pop();
                                            }
                                          },
                                          backgroundColor: appThemeColor.common,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          backgroundColor: appThemeColor.button,
                        ),
                ),

                SizedBox(height: 16),

                CommonElevatedButton(
                  text: 'Cancel',
                  textStyle: TextStyle(
                    color: appThemeColor.text4,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  width: double.infinity,
                  onPressed: () {
                    Get.back();
                  },
                  backgroundColor: appThemeColor.cart,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isFinal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isFinal ? 16 : 14,
            fontWeight: isFinal ? FontWeight.w600 : FontWeight.w400,
            color: isFinal ? const Color(0xFF2E7D5C) : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isFinal ? 16 : 14,
            fontWeight: isFinal ? FontWeight.w600 : FontWeight.w500,
            color: isFinal ? const Color(0xFF2E7D5C) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
