import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_size.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final FontStyle fontStyle;
  final Color fontColor;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign textAlignment;

  final String? fontFamily;


  final bool underline;
  final Color? underlineColor;
  final double underlineWidth;

  const TextWidget({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 14,
    this.fontStyle = FontStyle.normal,
    this.fontColor = Colors.black,
    this.overflow,
    this.maxLines,
    this.textAlignment = TextAlign.center,
    this.fontFamily,
    this.underline = false,
    this.underlineColor,
    this.underlineWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlignment,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: ResponsiveUtils.width(fontSize),
        fontStyle: fontStyle,
        color: fontColor,
        fontFamily: GoogleFonts.outfit().fontFamily,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        decorationColor: underline ? underlineColor : null,
        decorationThickness: underline ? underlineWidth : null,

      ),
    );
  }
}
