import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/app_size.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? text;
  final Widget? textWidget;
  final Widget? action;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle; // Add centerTitle property
  final Color? backgroundColor;
  final Color? statusBarColor;
  final Widget? leading;
  final bool showLeading;
  final List<Widget>? actions; // Add actions list

  const AppbarWidget({
    super.key,
    this.text,
    this.textWidget,
    this.action,
    this.bottom,
    this.centerTitle,
    this.backgroundColor,
    this.statusBarColor,
    this.leading,
    this.showLeading = true,
    this.actions, // Add to constructor
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);
    return AppBar(
      systemOverlayStyle: statusBarColor != null
          ? SystemUiOverlayStyle(
              statusBarColor: statusBarColor,
              statusBarIconBrightness: Brightness.light,
            )
          : SystemUiOverlayStyle.dark,
      flexibleSpace: Container(color: backgroundColor ?? Colors.white),
      //titleSpacing: showLeading ? 1 : -35,
      leading: showLeading
          ? (leading ??
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                ))
          : Container(),
      titleSpacing: -4,
      actions:
          actions ??
          (action != null
              ? [action!]
              : null), // Use actions or fallback to action
      title:
          textWidget ??
          Text(
            text ?? "",
            style: TextStyle(
              fontSize: ResponsiveUtils.width(20),
              fontWeight: FontWeight.w500,
              color: Colors.green.shade500,
            ),
          ),
      bottom: bottom,
      // Add bottom to AppBar
      centerTitle: centerTitle, // Set centerTitle in AppBar
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
