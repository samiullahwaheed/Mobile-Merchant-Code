import 'package:flutter/material.dart';
import '../../utils/app_size.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final VoidCallback? onTapSuffix;
  final Function(String submit)? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final bool? readOnly;

  // 👉 Border customization
  final Color borderColor;
  final Color focusedBorderColor;
  final double borderRadius;
  final double borderWidth;

  // 👉 UI customization
  final Widget? prefixIcon;
  final Widget? customSuffixIcon;
  final double? height;
  final double? width;
  final Color? hintColor;
  final VoidCallback? onTap;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.onTapSuffix,
    this.onFieldSubmitted,
    this.onChanged,
    this.borderColor = const Color(0xFF181818),
    this.focusedBorderColor = const Color(0xFF181818),
    this.borderRadius = 12, // 👉 default radius (changeable)
    this.borderWidth = 1,
    this.prefixIcon,
    this.customSuffixIcon,
    this.height,
    this.width,
    this.hintColor,
    this.readOnly,
    this.onTap,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.suffixIcon ?? false;
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);

    // 👉 Dynamic padding based on height
    EdgeInsetsGeometry contentPadding;

    if (widget.height != null) {
      contentPadding = EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.width(16),
        vertical: 0, // height controlled by SizedBox
      );
    } else {
      contentPadding = EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.width(16),
        vertical: ResponsiveUtils.height(14),
      );
    }

    return SizedBox(
      height: widget.height, // ✅ height control
      width: widget.width,
      child: TextFormField(
        onTap: widget.onTap,
        readOnly: widget.readOnly ?? false,
        controller: widget.controller,
        validator: widget.validator,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        onFieldSubmitted: widget.onFieldSubmitted,
        onChanged: widget.onChanged,
        cursorColor: const Color(0xFF3FAE6A),
        style: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.hintColor ?? Colors.grey,
            fontSize: ResponsiveUtils.width(14),
          ),

          // 👉 Icons
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon ?? false
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Icon(
                    obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                )
              : widget.customSuffixIcon,

          contentPadding: contentPadding,

          // 👉 Borders with dynamic radius
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: widget.focusedBorderColor,
              width: widget.borderWidth,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: Colors.red,
              width: widget.borderWidth,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: Colors.red,
              width: widget.borderWidth,
            ),
          ),
        ),
        autovalidateMode:
            AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

