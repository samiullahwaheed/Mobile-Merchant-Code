import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedValue;
  final String hint;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  final Color borderColor;
  final double borderRadius;
  final Color? fillColor;
  final Color? itemTextColor;
  final Color? dropdownColor;

  const CustomDropdown({
    super.key,
    required this.items,
    this.selectedValue,
    required this.hint,
    this.onChanged,
    this.validator,
    this.borderColor = const Color(0xFF181818),
    this.borderRadius = 8.0,
    this.fillColor,
    this.itemTextColor,
    this.dropdownColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      value: selectedValue,
      isExpanded: true,

      iconStyleData: const IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
      ),

      // ⭐ This controls dropdown popup spacing (like margin)
      dropdownStyleData: DropdownStyleData(
        offset: const Offset(0, 10), // Gap below field
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: dropdownColor ?? Colors.white,
        ),
        padding: const EdgeInsets.all(10),
      ),

      decoration: InputDecoration(
        filled: fillColor != null,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorStyle: TextStyle(
          fontStyle: GoogleFonts.outfit().fontStyle,
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      hint: TextWidget(
        text: hint,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        fontColor: Colors.grey,
      ),

      items: items.map((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: TextWidget(
            text: value.toString(),
            fontWeight: FontWeight.w500,
            fontSize: 14,
            fontColor: itemTextColor ?? Colors.black,
          ),
        );
      }).toList(),

      onChanged: onChanged,
      validator: validator,
    );
  }
}
