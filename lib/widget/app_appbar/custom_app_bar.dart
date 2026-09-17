import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merchent/constant/app_color/app_theme_color.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import 'package:merchent/utils/app_size.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? text;
  final Widget? textWidget;

  final Widget? action;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle; // Add centerTitle property
  final Color? backgroundColor;
  final Widget? leading;
  final bool showLeading;

  const AppbarWidget({
    super.key,
    this.text,
    this.textWidget,
    this.action,
    this.bottom,
    this.centerTitle, // Add centerTitle to constructor
    this.backgroundColor,
    this.leading,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return AppBar(
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: appThemeColor.button1,
      elevation: 0,
      leading: showLeading
          ? (leading ??
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: appThemeColor.text2,
                    size: 20,
                  ),
                ))
          : Container(),
      titleSpacing: -4,
      actions: action != null ? [action!] : null,
      title:
          textWidget ??
          TextWidget(
            text: text ?? "",

            fontSize: AppSize.width(value: 20),
            fontWeight: FontWeight.w500,
            fontColor: appThemeColor.text2,
          ),
      bottom: bottom,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
