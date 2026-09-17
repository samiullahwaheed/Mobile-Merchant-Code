import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:merchent/constant/app_color/app_color.dart';
import '../../constant/app_color/app_theme_color.dart';

class CustomDateRangePicker extends StatefulWidget {
  final Function(DateTimeRange)? onRangeSelected;
  final Color? primaryColor;

  const CustomDateRangePicker({
    super.key,
    this.onRangeSelected,
    this.primaryColor,
  });

  @override
  _CustomDateRangePickerState createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTimeRange? pickedRange;
  late PickerDateRange pickerDateRange;

  Color get primaryColor =>
      widget.primaryColor ?? Theme.of(context).primaryColor;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize with a valid date (7 days ago from today)
    final DateTime validStartDate = DateTime.now().subtract(
      const Duration(days: 7),
    );
    pickedRange = DateTimeRange(
      start: validStartDate,
      end: validStartDate.add(const Duration(days: 6)),
    );
    pickerDateRange = PickerDateRange(
      validStartDate,
      validStartDate.add(const Duration(days: 6)),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      final DateTime pressedDate = args.value;
      final DateTime today = DateTime.now();
      final DateTime todayMidnight = DateTime(
        today.year,
        today.month,
        today.day,
      );
      final DateTime pressedDateMidnight = DateTime(
        pressedDate.year,
        pressedDate.month,
        pressedDate.day,
      );

      // Calculate the cutoff date (today - 5 days)
      // Any date from (today - 5 days) to today should be blocked
      final DateTime cutoffDate = todayMidnight.subtract(
        const Duration(days: 5),
      );

      // Check if the selected date is from cutoff date to today (inclusive)
      if (pressedDateMidnight.isAtSameMomentAs(cutoffDate) ||
          (pressedDateMidnight.isAfter(cutoffDate) &&
              pressedDateMidnight.isBefore(
                todayMidnight.add(const Duration(days: 1)),
              ))) {
        setState(() {
          errorMessage =
              'You cannot select current date or any date within the last 5 days.';
        });
        return; // Stop further execution
      }

      // Clear any previous error message and select the range from the selected date to 6 days ahead
      setState(() {
        errorMessage = ''; // Clear any previous error message
        pickerDateRange = PickerDateRange(
          pressedDate,
          pressedDate.add(const Duration(days: 6)), // 7 days from selected date
        );
        pickedRange = DateTimeRange(
          start: pressedDate,
          end: pressedDate.add(
            const Duration(days: 6),
          ), // 7 days from selected date
        );
      });

      // Trigger callback if provided
      if (widget.onRangeSelected != null && pickedRange != null) {
        widget.onRangeSelected!(pickedRange!);
        // Pop back with the selected range
        Navigator.pop(context, pickedRange);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final DateTime todayMidnight = DateTime(today.year, today.month, today.day);
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    return Scaffold(
      backgroundColor: appThemeColor.surfacePrimary,
      appBar: AppBar(
        title: const Text(
          "Select Date Range",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: AppColor.backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card with Instructions
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.backgroundColor.withOpacity(0.15),
                    AppColor.backgroundColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColor.backgroundColor.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColor.backgroundColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "How it works",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColor.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "You can select any date from the past except current date and last 5 days. You can select dates from any month or year.",
                    style: TextStyle(
                      fontSize: 14,
                      color: appThemeColor.text2.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Error Message
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Calendar Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: appThemeColor.surfacePrimary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: appThemeColor.text2.withOpacity(0.05),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.single,
                  onSelectionChanged: _onSelectionChanged,
                  initialSelectedRange: pickerDateRange,
                  // Set maximum date to 6 days ago (so today and last 5 days are blocked)
                  maxDate: todayMidnight.subtract(const Duration(days: 6)),
                  // No minimum date restriction - can select any old date
                  minDate: null,
                  headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: AppColor.backgroundColor.withOpacity(0.1),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColor.backgroundColor,
                    ),
                  ),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    firstDayOfWeek: 1, // Start week on Monday
                    weekendDays: const [6, 7], // Saturday and Sunday
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                        color: appThemeColor.text2.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    specialDates: pickedRange != null
                        ? _generateDateRange(
                            pickedRange!.start,
                            pickedRange!.end,
                          )
                        : [],
                    dayFormat: 'EEE',
                    showTrailingAndLeadingDates: true,
                  ),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    textStyle: TextStyle(color: appThemeColor.text2),
                    todayTextStyle: TextStyle(
                      color: appThemeColor.text2.withOpacity(0.4),
                      fontWeight: FontWeight.bold,
                    ),
                    specialDatesTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    specialDatesDecoration: BoxDecoration(
                      color: AppColor.backgroundColor.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    weekendTextStyle: const TextStyle(color: Color(0xFFE57373)),
                    // Style for disabled dates (today and future)
                    disabledDatesTextStyle: TextStyle(
                      color: appThemeColor.text2.withOpacity(0.2),
                      fontWeight: FontWeight.normal,
                    ),
                    trailingDatesTextStyle: TextStyle(
                      color: appThemeColor.text2.withOpacity(0.3),
                    ),
                    leadingDatesTextStyle: TextStyle(
                      color: appThemeColor.text2.withOpacity(0.3),
                    ),
                  ),
                  selectionTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  selectionColor: AppColor.backgroundColor,
                  todayHighlightColor: AppColor.backgroundColor.withOpacity(
                    0.3,
                  ),
                ),
              ),
            ),

            // Selected Range Display
            if (pickedRange != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: appThemeColor.surfacePrimary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: AppColor.backgroundColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.backgroundColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.date_range,
                            color: AppColor.backgroundColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Selected Period",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: appThemeColor.text2.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "FROM",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(pickedRange!.start),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: appThemeColor.text2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: AppColor.backgroundColor,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "TO",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(pickedRange!.end),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: appThemeColor.text2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _generateDateRange(DateTime start, DateTime end) {
    List<DateTime> dates = [];
    DateTime current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }
}
