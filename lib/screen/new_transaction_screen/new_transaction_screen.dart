import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/common_widget/common_button_widget.dart';
import 'package:merchent/widget/appbar_widget/appbar_widget.dart';
import '../../constant/app_color/app_theme_color.dart';
import '../common_widget/common_text_widget.dart';
import 'controller/new_transaction_controller.dart';

class NewTransaction extends StatelessWidget {
  NewTransaction({super.key});

  final NewTransactionController controller = Get.put(
    NewTransactionController(),
  );

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    return Scaffold(
      backgroundColor: appThemeColor.surfacePrimary,
      appBar: AppbarWidget(
        backgroundColor: appThemeColor.button1,
        textWidget: TextWidget(
          text: 'New Transaction',
          fontWeight: FontWeight.w700,
          fontSize: 18,
          fontColor: appThemeColor.text2,
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new, color: appThemeColor.text2),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Find Customer by Card ID Section
            _buildSectionTitle(
              textTitle: 'Find Customer by Card ID',
              color: appThemeColor.text2,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: controller.cardIdController,
                    hintText: 'Enter Card Code (e.g., XY9OWARA)',
                  ),
                ),
                SizedBox(width: 12),
                Obx(
                  () => controller.isLoading.value
                      ? SizedBox(
                          width: 80,
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: appThemeColor.button,
                            ),
                          ),
                        )
                      : CommonElevatedButton(
                          text: 'Find',
                          textStyle: TextStyle(color: appThemeColor.text1),
                          onPressed: () {
                            controller.findPromotion();
                          },
                          backgroundColor: appThemeColor.button,
                        ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Available Point Section
            _buildSectionTitle(
              textTitle: 'Available Point',
              color: appThemeColor.text2,
            ),
            SizedBox(height: 8),
            _buildTextField(
              controller: controller.availablePointController,
              hintText: '0',
              readOnly: true,
            ),

            SizedBox(height: 24),

          
            // Total Bill Amount Section
            _buildSectionTitle(
              textTitle: 'Total Bill Amount(Excluding Promos)',
              color: appThemeColor.text2,
            ),
            SizedBox(height: 8),
            _buildTextField(
              controller: controller.billAmountController,
              hintText: 'Enter bill amount',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),

            SizedBox(height: 24),

            // Point Redeem Section
            _buildSectionTitle(
              textTitle: 'Point Redeemed',
              color: appThemeColor.text2,
            ),
            SizedBox(height: 8),
            Obx(
              () => _buildTextField(
                isInt: true,
                controller: controller.pointRedeemController,
                hintText: 'Enter points to redeem',
                readOnly: controller.isPCcard.value,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            SizedBox(height: 24),

            // Gross Point Section
            _buildSectionTitle(
              textTitle: 'Gross Value of Promotions',
              color: appThemeColor.text2,
            ),
            SizedBox(height: 8),
            _buildTextField(
              controller: controller.grossPointController,
              hintText: '0',
              readOnly: true,
            ),

            SizedBox(height: 24),

            // Gift Card Available Section - Only show when promotions exist
            Obx(() {
              final activePromos = controller.activePromotions;
              final hasPromotions = activePromos.isNotEmpty;

              if (!hasPromotions) {
                return SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    textTitle: 'Gift Card Available',
                    color: appThemeColor.text2,
                  ),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: activePromos.map((promotion) {
                          // Multi-selection check
                          final isSelected = controller.selectedPromotions.any(
                            (p) => p.id == promotion.id,
                          );

                          return GestureDetector(
                            onTap: () => controller.selectPromotion(promotion),
                            child: Container(
                              width:
                                  280, // Fixed width for consistent card size
                              margin: EdgeInsets.only(right: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.green.shade800
                                      : Colors.green,
                                  width: isSelected ? 3 : 2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Gift Card Name: ${promotion.name}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Discount: ${promotion.discountPercentage}% OFF',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (promotion.grossValue != null &&
                                      promotion.grossValue! > 0) ...[
                                    SizedBox(height: 4),
                                    Text(
                                      'Gross Value: ${promotion.grossValue}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              );
            }),

            SizedBox(height: 16),

            Obx(() {
              final hasPromotion = controller.selectedPromotions.isNotEmpty;
              final isPCcard = controller.isPCcard.value;
              // PC card হলে promotion select না করলে disable; PC না হলে সবসময় enable
              final isAddCalcEnabled = isPCcard ? hasPromotion : true;
              return CommonElevatedButton(
                text: 'Apply Calculation',
                width: double.infinity,
                textStyle: TextStyle(
                  color: appThemeColor.text1,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                onPressed: isAddCalcEnabled
                    ? () => controller.applyGiftCards()
                    : null,
                backgroundColor: appThemeColor.button,
              );
            }),

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
                controller.resetForm();
                Get.back();
              },
              backgroundColor: appThemeColor.cart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({String? textTitle, Color? color}) {
    return Text(
      textTitle ?? '',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool readOnly = false,
    bool isInt = false, // নতুন প্যারামিটার
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        // যদি isInt true হয়, তবে কিবোর্ড নাম্বার মোডে সেট হবে
        keyboardType: isInt ? TextInputType.number : keyboardType,
        // যদি isInt true হয়, তবে শুধুমাত্র ডিজিট ইনপুট নেবে
        inputFormatters: isInt
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        style: TextStyle(
          fontSize: 16,
          color: readOnly ? Colors.grey[600] : Colors.black87,
        ),
      ),
    );
  }

  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String hintText,
  //   bool readOnly = false,
  //   TextInputType keyboardType = TextInputType.text,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(25),
  //       border: Border.all(color: Colors.green, width: 2),
  //     ),
  //     child: TextField(
  //       controller: controller,
  //       readOnly: readOnly,
  //       keyboardType: keyboardType,
  //       decoration: InputDecoration(
  //         hintText: hintText,
  //         border: InputBorder.none,
  //         contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  //         hintStyle: TextStyle(color: Colors.grey[500]),
  //       ),
  //       style: TextStyle(
  //         fontSize: 16,
  //         color: readOnly ? Colors.grey[600] : Colors.black87,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    bool isFullWidth = false,
    required Color buttonBackgroundColor,
    required Color titleColor,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackgroundColor,
          foregroundColor: titleColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isFullWidth ? 0 : 24,
            vertical: 0,
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildPromotionCard(dynamic promo, AppThemeColor appThemeColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${promo.discountPercentage}% OFF',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  promo.promotionType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            promo.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Valid until: ${_formatDate(promo.endDate)}',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
