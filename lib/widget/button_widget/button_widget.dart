import 'package:flutter/material.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import '../../utils/app_size.dart';

class ButtonWidget extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final double? iconHeight;
  final double? iconWidth;
  final Color textColor;
  final double fontSize;
  final VoidCallback? onPressed;
  final double buttonHeight;
  final double buttonWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry buttonRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final FontWeight? fontWeight;
  final bool isLoading; //

  const ButtonWidget({
    super.key,
    this.label,
    this.icon,
    this.iconHeight,
    this.iconWidth,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.onPressed,
    this.buttonHeight = 52,
    this.buttonWidth = 339,
    this.padding,
    this.buttonRadius = const BorderRadius.all(Radius.circular(8)),
    this.backgroundColor,
    this.borderColor,
    this.fontWeight,
    this.isLoading = false, // ✅ default false
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);
    return Container(
      height: ResponsiveUtils.height(buttonHeight),
      width: ResponsiveUtils.width(buttonWidth),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.green.shade500,
        borderRadius: buttonRadius,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
      ),
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed, // ✅ লোডিং হলে disable হবে
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: buttonRadius),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : label != null
            ? TextWidget(
                text: label!,
                fontColor: textColor,
                fontSize: ResponsiveUtils.width(fontSize),
                fontWeight: fontWeight ?? FontWeight.w500,
              )
            : (icon != null ? SizedBox(child: icon) : const SizedBox()),
      ),
    );
  }
}
