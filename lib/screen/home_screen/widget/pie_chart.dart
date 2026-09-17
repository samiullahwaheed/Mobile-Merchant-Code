import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:merchent/utils/app_size.dart';

import '../model/model.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({
    super.key,
    required this.items,
    required this.colors,
    required this.totalSell,
  });

  final List<WeeklyReportItem> items;
  final List<Color> colors;
  final num totalSell;

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 1,
              centerSpaceRadius: AppSize.width(value: 55),
              pieTouchData: PieTouchData(
                touchCallback: (event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: _buildSections(),
            ),
          ),
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _formatTotalSell(widget.totalSell),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: _fontSizeForValue(widget.totalSell),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
         
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    if (widget.items.isEmpty) {
      return [];
    }

    return List.generate(widget.items.length, (index) {
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 60 : 50;
      final color = widget.colors[index % widget.colors.length];
      final value = widget.items[index].totalSell.toDouble();

      return PieChartSectionData(
        color: color,
        value: value == 0 ? 0.0001 : value,
        radius: radius,
        showTitle: isTouched,
        title: isTouched ? '${widget.items[index].totalSell}' : '',
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  String _formatTotalSell(num total) {
    return _normalizeNumber(total);
  }



  double _fontSizeForValue(num total) {
    final length = _formatTotalSell(total).length;

    if (length <= 4) return 34;
    if (length == 5) return 28;
    if (length == 6) return 24;
    if (length == 7) return 20;
    if (length == 8) return 16;
    if (length == 9) return 14;
    if (length == 10) return 12;
    if (length == 11) return 10;
    return 8;
  }

  String _normalizeNumber(num total) {
    if (total is int || total == total.roundToDouble()) {
      return total.toInt().toString();
    }

    final value = total.toStringAsFixed(1);
    return value.endsWith('.0') ? value.substring(0, value.length - 2) : value;
  }
}
