import 'package:flutter/material.dart';

import 'common_text_widget.dart';

class CommonElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double? width;
  final double borderRadius;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  @override
  final Key? key;

  const CommonElevatedButton({
    required this.text,
    this.onPressed,
    this.height = 50,
    this.width,
    this.borderRadius = 8,
    required this.backgroundColor,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
          elevation: 0,
        ),
        child: TextWidget(
          text: text,
          fontWeight: textStyle?.fontWeight ?? FontWeight.w600,
          fontSize: textStyle?.fontSize ?? 16,
          fontColor: textStyle?.color ?? Colors.white,

         
        ),
      ),
    );
  }
}
