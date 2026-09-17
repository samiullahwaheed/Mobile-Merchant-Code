import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../constant/app_color/app_theme_color.dart';
import '../controller/controller.dart';
import '../model/customer_chart_model.dart';

/// Highest stacked bar (discount + revenue) across months.
double _maxStackAcrossMonths(List<MonthlyChartData> monthlyData) {
  double maxH = 0;
  for (final m in monthlyData) {
    final h = m.totalDiscount + m.totalRevenue;
    if (h > maxH) maxH = h;
  }
  return maxH;
}

/// Rounds up to a readable cap, e.g. 12345 → 13000 (ceil to next 1k when in 10k range).
double _niceChartMaxY(double rawMax) {
  if (rawMax <= 0) return 1;
  final log10 = math.log(rawMax) / math.ln10;
  if (!log10.isFinite) return 1;
  final pow10 = math.pow(10.0, log10.floor()).toDouble();
  final step = pow10 / 10;
  if (step <= 0) return math.max(1, rawMax.ceilToDouble());
  return ((rawMax / step).ceil() * step).toDouble();
}

String _compactAxisMantissa(double x) {
  final rounded = (x * 10).round() / 10;
  if ((rounded - rounded.round()).abs() < 1e-9) {
    return '${rounded.round()}';
  }
  final s = rounded.toStringAsFixed(1);
  if (s.endsWith('.0')) return s.substring(0, s.length - 2);
  return s;
}

/// Compact Y labels: 2k, 13k, 200k, 1.2M, etc.
String _formatCompactAxis(double v) {
  if (v == 0) return '0';
  final sign = v < 0 ? '-' : '';
  final a = v.abs();
  if (a >= 1e9) {
    return sign + _compactAxisMantissa(a / 1e9) + 'B';
  }
  if (a >= 1e6) {
    return sign + _compactAxisMantissa(a / 1e6) + 'M';
  }
  if (a >= 1e3) {
    return sign + _compactAxisMantissa(a / 1e3) + 'k';
  }
  if (a == a.roundToDouble()) {
    return sign + a.toInt().toString();
  }
  return sign + a.toStringAsFixed(0);
}

class BarTouch extends StatelessWidget {
  const BarTouch({super.key, required this.appThemeColor});

  final AppThemeColor appThemeColor;

  @override
  Widget build(BuildContext context) {
    final HomeScreenController controller = Get.find<HomeScreenController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Chart',
                style: TextStyle(
                  color: appThemeColor.text4,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: appThemeColor.text1,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Obx(
                  () => DropdownButton<int>(
                    value: controller.selectedChartYear.value,
                    dropdownColor: appThemeColor.text1,
                    underline: const SizedBox(),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: appThemeColor.text2,
                    ),
                    items: controller.chartYearOptions
                        .map(
                          (year) => DropdownMenuItem(
                            value: year,
                            child: Text(
                              '$year',
                              style: TextStyle(
                                color: appThemeColor.text2,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: controller.changeChartYear,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          /// BODY
          Obx(() {
            if (controller.isCustomerChartLoading.value) {
              return SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.customerChartError.value.isNotEmpty) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    controller.customerChartError.value,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            final monthlyData = controller.monthlyChartData;

            final double rawMax = _maxStackAcrossMonths(monthlyData);
            final double maxY = _niceChartMaxY(rawMax);
            final double yInterval = maxY / 6;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      minY: 0,
                      maxY: maxY,

                      /// TOUCH
                      barTouchData: BarTouchData(
                        enabled: true,
                        handleBuiltInTouches: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final m = monthlyData[groupIndex];

                            final label = rodIndex == 0
                                ? 'Discount'
                                : 'Revenue';

                            final originalValue = rodIndex == 0
                                ? m.totalDiscount
                                : m.totalRevenue;

                            return BarTooltipItem(
                              '$label: ${originalValue.toInt()}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),

                      /// TITLES
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                              );

                              if (value.toInt() >= 0 &&
                                  value.toInt() < monthlyData.length) {
                                final month = monthlyData[value.toInt()].month;

                                return Text(
                                  DateFormat(
                                    'MMM',
                                  ).format(DateTime(2000, month)),
                                  style: style,
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: yInterval,
                            getTitlesWidget: (value, meta) {
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  _formatCompactAxis(value),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      borderData: FlBorderData(show: false),

                      /// BAR GROUPS
                      barGroups: List.generate(monthlyData.length, (index) {
                        final m = monthlyData[index];
                        final discount = m.totalDiscount;
                        final revenue = m.totalRevenue;

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            /// Discount
                            BarChartRodData(
                              fromY: 0,
                              toY: discount,
                              color: Colors.red.shade400,
                              width: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),

                            /// Revenue
                            BarChartRodData(
                              fromY: discount,
                              toY: discount + revenue,
                              color: Colors.green.shade400,
                              width: 6,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                          showingTooltipIndicators: [],
                        );
                      }),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                /// LEGEND
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LegendItem(color: Colors.green[400]!, label: 'Revenue'),
                    SizedBox(width: 24),
                    _LegendItem(color: Colors.red[400]!, label: 'Discount'),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
