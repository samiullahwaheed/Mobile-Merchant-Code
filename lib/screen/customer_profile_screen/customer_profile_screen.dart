import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:merchent/constant/app_api_end_point.dart';
import '../../../utils/app_size.dart';
import '../../../widget/app_image/app_image_circular.dart';
import '../../../widget/appbar_widget/appbar_widget.dart';
import '../../constant/app_color/app_theme_color.dart';
import '../common_widget/common_text_widget.dart';
import '../customer_details_screen/model/customer_details_model.dart';
import 'controller/customer_transaction_controller.dart';

class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerData customer = Get.arguments as CustomerData;
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    final controller = Get.put(CustomerTransactionController());
    if (customer.sId != null) {
      controller.fetchTransactions(customer.sId!);
    }

    return Scaffold(
      backgroundColor: appThemeColor.surfacePrimary,
      appBar: AppbarWidget(
        backgroundColor: appThemeColor.button1,
        textWidget: TextWidget(
          text: 'Customer Profile',
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  AppImageCircular(
                    fit: BoxFit.cover,
                    url: AppApiEndPoint.mediaUrl(customer.profile),
                    width: AppSize.width(value: 148),
                    height: AppSize.width(value: 148),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: appThemeColor.stroke2),
                        borderRadius: BorderRadius.circular(
                          AppSize.width(value: 24),
                        ),
                        color: appThemeColor.surfacePrimary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Customer Profile Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: appThemeColor.common, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Name:', customer.name ?? 'N/A'),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Customer ID:',
                      customer.customUserId ?? 'N/A',
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Loyalty Points',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                          () => _buildInfoRow(
                        'Points Balance:',
                        (Get.find<CustomerTransactionController>()
                            .tierData
                            .value
                            ?.availablePoints ??
                            0)
                            .toStringAsFixed(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                          () => _buildInfoRow(
                        'Tier:',
                        Get.find<CustomerTransactionController>()
                            .tierData
                            .value
                            ?.tierName ??
                            'N/A',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Transaction History Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(246, 246, 247, 1),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: appThemeColor.common, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'SL',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: appThemeColor.common,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Date',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: appThemeColor.common,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Earned',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: appThemeColor.common,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Used',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: appThemeColor.common,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Transaction History List - Fixed: Using Container with height instead of Expanded
              Container(
                height: 300, // Fixed height for the list
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: appThemeColor.common, width: 1),
                ),
                child: GetX<CustomerTransactionController>(
                  // init: CustomerTransactionController(), // Removed as it is already injected
                  // initState: (_) { ... } // Removed as fetch is triggered in build
                  builder: (controller) {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.transactionList.isEmpty) {
                      return const Center(child: Text("No transactions found"));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.transactionList.length,
                      itemBuilder: (context, index) {
                        final transaction = controller.transactionList[index];
                        return _buildTransactionRow(
                          sl: '${index + 1}',
                          date:
                          transaction.createdAt != null &&
                              transaction.createdAt!.length >= 10
                              ? transaction.createdAt!.substring(0, 10)
                              : 'N/A',
                          reward:
                          '${(transaction.pointsEarned ?? 0).toStringAsFixed(2)}',
                          pointsUsed:
                          '${(transaction.pointRedeemed ?? 0).toStringAsFixed(2)}',
                          textColor: appThemeColor.common,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),

        Expanded(
          child: Text(
            " $value",
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionRow({
    required String sl,
    required String date,
    required String reward,
    required String pointsUsed,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(sl, style: TextStyle(fontSize: 16, color: textColor)),
          ),
          Expanded(
            flex: 2,
            child: Text(date, style: TextStyle(fontSize: 14, color: textColor)),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              reward,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              pointsUsed,
              style: TextStyle(fontSize: 16, color: textColor),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}