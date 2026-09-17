import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/routes/app_routes.dart';
import 'package:merchent/utils/app_size.dart';
import '../../constant/app_color/app_color.dart';
import '../../constant/app_color/app_theme_color.dart';
import '../../widget/appbar_widget/appbar_widget.dart';
import '../common_widget/common_text_widget.dart';
import 'controller/customer_details_controller.dart';

class CustomerTableScreen extends StatefulWidget {
  const CustomerTableScreen({super.key});

  @override
  _CustomerTableScreenState createState() => _CustomerTableScreenState();
}

class _CustomerTableScreenState extends State<CustomerTableScreen> {
  TextEditingController searchController = TextEditingController();
  final CustomerDetailsController controller = Get.put(
    CustomerDetailsController(),
  );

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
        showLeading: false,
        backgroundColor: appThemeColor.button1,
        textWidget: TextWidget(
          text: 'Customer Details',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: appThemeColor.cart,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.green, width: 1),
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
                style: TextStyle(color: Colors.green[700]),
              ),
            ),
            SizedBox(height: 20),

            // Data Table
            Expanded(
              child: Container(
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
                        color: Colors.green,
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
                                'ID',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                'Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                'Point\'s',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                           
                            Expanded(
                              flex: 1,
                              child: Text(
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                'View',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Table Rows
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await controller.refreshList();
                        },
                        child: Obx(() {
                          controller.isLoadingMore.value;
                          controller.hasReachedEnd.value;
                          if (controller.isLoading.value &&
                              !controller.isLoadingMore.value) {
                            return Center(child: CircularProgressIndicator());
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
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          final list = controller.customerList;
                          return ListView.builder(
                            controller: controller.scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount:
                                list.length + (list.isEmpty ? 0 : 1),
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
                                      color: Colors.white,
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
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          customer.customUserId ?? '',
                                          style: TextStyle(
                                            fontSize: AppSize.width(value: 12),
                                            color: appThemeColor.text2,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          customer.name?.split(' ').first ?? '',
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: AppSize.width(value: 12),
                                            color: appThemeColor.text2,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          (customer.totalPointsEarned ?? 0)
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: AppSize.width(value: 12),
                                            color: appThemeColor.text2,
                                          ),
                                        ),
                                      ),
                                      // Expanded(
                                      //   flex: 1,
                                      //   child: Text(
                                      //     (customer.finalBilled ?? 0)
                                      //         .toStringAsFixed(2),
                                      //     style: TextStyle(
                                      //       fontSize: 13,
                                      //       color: appThemeColor.text2,
                                      //     ),
                                      //   ),
                                      // ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                Get.toNamed(
                                                  AppRoutes.customerProfilePage,
                                                  arguments: customer,
                                                );
                                              },

                                              icon: Icon(
                                                Icons.visibility,
                                                color: Colors.green,
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
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
