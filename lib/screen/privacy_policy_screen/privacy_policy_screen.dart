import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/common_widget/common_text_widget.dart';
import '../../../widget/appbar_widget/appbar_widget.dart';
import '../../constant/app_color/app_theme_color.dart';
import '../../constant/content/privacy_policy_content.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;

    return Scaffold(
      appBar: AppbarWidget(
        backgroundColor: appThemeColor.button1,
        textWidget: TextWidget(
          text: 'Privacy Policy',
          fontWeight: FontWeight.w700,
          fontSize: 18,
          fontColor: appThemeColor.text2,
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new, color: appThemeColor.text2),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Html(
          data: kPrivacyPolicyHtml,
          style: {
            "body": Style(
              color: appThemeColor.text2,
              fontSize: FontSize(14),
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
            ),
            "p": Style(color: appThemeColor.text2),
            "span": Style(color: appThemeColor.text2),
            "li": Style(color: appThemeColor.text2),
            "h1": Style(color: appThemeColor.text2),
            "h2": Style(color: appThemeColor.text2),
            "h3": Style(color: appThemeColor.text2),
          },
        ),
      ),
    );
  }
}
