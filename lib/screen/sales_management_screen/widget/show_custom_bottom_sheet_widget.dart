import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/routes/app_routes.dart';
import '../../../constant/app_color/app_color.dart';
import 'qr_scanner_screen.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key});

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
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.grey, size: 20),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Buttons Row
          Row(
            children: [
              // Scan Now Button
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E8), // Light green background
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFF4CAF50), // Green border
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () async {
                        // Close bottom sheet first
                        Navigator.pop(context);

                        // Navigate to QR Scanner and wait for result
                        final String? scannedCode = await Get.to<String>(
                          () => QrScannerScreen(),
                        );

                        // If code was scanned, navigate to NewTransaction with the code
                        if (scannedCode != null && scannedCode.isNotEmpty) {
                          Get.toNamed(
                            AppRoutes.newTransaction,
                            arguments: {'cardCode': scannedCode},
                          );
                        }
                      },
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              color: Color(0xFF4CAF50),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Scan Now',
                              style: TextStyle(
                                color: Color(0xFF4CAF50),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Add Rewards Button
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColor.backgroundColor, // Green background
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        // Handle add rewards action
                        Navigator.pop(context);
                        Get.toNamed(AppRoutes.newTransaction);
                      },
                      child: const Center(
                        child: Text(
                          'Input Sales',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Function to show the bottom sheet
void showCustomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return const CustomBottomSheet();
    },
  );
}
