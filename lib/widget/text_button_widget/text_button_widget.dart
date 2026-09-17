import 'package:flutter/material.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';

import '../../utils/app_size.dart';

class TextButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration? decoration;
  final Color? decorationColor;

  const TextButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.fontWeight,
    this.decoration,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(50, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
      ),
      child: TextWidget(
        text: text,
        // style: TextStyle(
        //   color: textColor,
        //   fontSize: ResponsiveUtils.width(fontSize),
        //   fontWeight: fontWeight,
        //   decoration: decoration,
        //   decorationColor: decorationColor,
        // ),
        fontColor: textColor,
        fontSize: ResponsiveUtils.width(fontSize),
        fontWeight: fontWeight,
        underlineColor: decorationColor,
      ),
    );
  }
}
