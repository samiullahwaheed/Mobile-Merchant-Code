import 'package:flutter/material.dart';
import 'package:merchent/screen/sell_details_screen/model/sell_details_model.dart';

class TransactionSummaryBottomSheet extends StatelessWidget {
  final SellDetailsData? customerData;

  const TransactionSummaryBottomSheet({super.key, this.customerData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildInfoRow('Customer Name', customerData?.name ?? 'N/A'),
                _buildInfoRow('Card ID', customerData?.cardIds ?? 'N/A'),
                _buildInfoRow(
                  'Total Amount',
                  customerData?.totalBilled.toString() ?? '0',
                ),
                _buildInfoRow(
                  'Point Redeem',
                  customerData?.totalPointsRedeemed.toString() ?? '0',
                  showRedDot: true,
                ),
                _buildInfoRow(
                  'Point Earned',
                  customerData?.totalPointsEarned.toString() ?? '0',
                ),
                _buildInfoRow(
                  'Final Amount',
                  customerData?.finalBilled.toString() ?? '0',
                ),
                _buildInfoRow(
                  'Transaction Status',
                  customerData?.status ?? 'N/A',
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool showRedDot = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (showRedDot) ...[
                const SizedBox(width: 8),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Static method to show the bottom sheet
  static void show(BuildContext context, {SellDetailsData? customerData}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          TransactionSummaryBottomSheet(customerData: customerData),
    );
  }
}
