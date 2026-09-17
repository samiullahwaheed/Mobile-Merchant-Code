import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/sell_details_screen/controller/sell_details_controller.dart';
import '../../constant/app_color/app_color.dart';
import '../../constant/app_color/app_theme_color.dart';
import '../../widget/appbar_widget/appbar_widget.dart';
import '../common_widget/common_text_widget.dart';
import '../total_summary_screen/widget/transaction_summary_bottom_sheet.dart';

class SellDetailsScreen extends StatefulWidget {
  SellDetailsScreen({super.key});

  @override
  _SellDetailsScreen createState() => _SellDetailsScreen();
}

class _SellDetailsScreen extends State<SellDetailsScreen> {
  TextEditingController searchController = TextEditingController();
  final SellDetailsController controller = Get.put(SellDetailsController());

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
          text: 'Sell Details',
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
                          Navigator.pop(context);
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
              color: AppColor.button2Dark,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: appThemeColor.cart,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColor.backgroundColor, width: 1),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  controller.onSearchChanged(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search by Customer Name',
                  hintStyle: TextStyle(
                    color: appThemeColor.common,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: appThemeColor.common,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                style: TextStyle(
                  color: AppColor.backgroundColor.withValues(alpha: 0.7),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Data Table
            Expanded(
              child: RefreshIndicator(
                color: AppColor.backgroundColor,
                onRefresh: () async {
                  await controller.refreshList();
                },
                child: Obx(() {
                  controller.isLoadingMore.value;
                  controller.hasReachedEnd.value;
                  if (controller.isLoading.value &&
                      !controller.isLoadingMore.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: AppColor.errorColor,
                                    size: 48,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    controller.errorMessage.value,
                                    style: TextStyle(
                                      color: appThemeColor.text2,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () =>
                                        controller.updateSortOption(
                                          controller.selectedOption.value,
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.backgroundColor,
                                    ),
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(
                                        color: AppColor.button2Dark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (controller.customerList.isEmpty) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Center(
                              child: Text(
                                'No customers found',
                                style: TextStyle(
                                  color: appThemeColor.text2,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  final list = controller.customerList;
                  return Container(
                    decoration: BoxDecoration(
                      color: appThemeColor.surfacePrimary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.backgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      color: AppColor.button1Light,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Point Redeem',
                                    style: TextStyle(
                                      color: AppColor.button1Light,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),

                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Final Amount',
                                    style: TextStyle(
                                      color: AppColor.button1Light,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Action',
                                    style: TextStyle(
                                      color: AppColor.button1Light,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Table Rows
                        Expanded(
                          child: ListView.builder(
                            controller: controller.scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: list.length + (list.isEmpty ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index >= list.length) {
                                if (controller.isLoadingMore.value) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: 28,
                                        width: 28,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColor.backgroundColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (controller.hasReachedEnd.value) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'End',
                                        style: TextStyle(
                                          color: appThemeColor.text2,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }
                              final customer = list[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColor.button1Light,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          customer.name.split(' ').first,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: appThemeColor.text2,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          customer.totalPointsRedeemed
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: appThemeColor.text2,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          customer.finalBilled.toStringAsFixed(
                                            2,
                                          ),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: appThemeColor.text2,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: AppColor.backgroundColor.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () =>
                                                  TransactionSummaryBottomSheet.show(
                                                    context,
                                                    customerData: customer,
                                                  ),
                                              icon: Icon(
                                                Icons.visibility,
                                                color: AppColor.backgroundColor,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
