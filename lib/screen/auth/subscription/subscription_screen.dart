import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merchent/constant/app_image_path.dart';
import '../../../utils/app_size.dart';
import '../../../widget/app_button/app_button.dart';
import '../../../widget/app_image/app_image.dart';
import '../../../widget/app_text/app_text.dart';
import '../../../widget/appbar_widget/appbar_widget.dart';

class MySubScreen extends StatelessWidget {
  const MySubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF3FAE6A), // Green background
        statusBarIconBrightness: Brightness.light, // White icons on Android
        statusBarBrightness: Brightness.dark, // White icons on iOS
      ),
      child: Scaffold(
        appBar: const AppbarWidget(),
        body: SizedBox(
          height: AppSize.size.height * 0.9,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return SizedBox(
                width: AppSize.size.width * 0.9,
                child: const SubcriptionCard(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SubcriptionCard extends StatelessWidget {
  const SubcriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(AppSize.width(value: 16)),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1), // Shadow color
                  offset: const Offset(
                    0,
                    2,
                  ), // Vertical offset, giving shadow on bottom
                  blurRadius: 8, // Blur radius
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1), // Shadow color
                  offset: const Offset(
                    0,
                    -2,
                  ), // Vertical offset, giving shadow on top
                  blurRadius: 8, // Blur radius
                ),
              ],
              borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.size.height * 0.04,
                    horizontal: AppSize.size.width * 0.1,
                  ),
                  child: Column(
                    spacing: AppSize.size.height * 0.02,
                    children: [
                      AppImage(
                        width: AppSize.width(value: 40),
                        height: AppSize.width(value: 40),
                        path: AppImagePath.icGldSub,
                      ),
                      AppText(
                        data: "Gold plan",
                        fontSize: AppSize.width(value: 18),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3FAE6A),
                      ),
                      AppText(
                        data: r"$40/mth",
                        fontSize: AppSize.width(value: 40),
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      AppText(
                        data: "Billed annually.",
                        fontSize: AppSize.width(value: 16),
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      const SubWidGetRow(text: "Advanced custom fields"),
                      const SubWidGetRow(text: "Audit log and data history"),
                      const SubWidGetRow(text: "Unlimited individual users"),
                      const SubWidGetRow(text: "Unlimited individual data"),
                      const SubWidGetRow(text: "Personalised+priotity service"),
                    ],
                  ),
                ),
                Container(
                  height: AppSize.height(value: 150),
                  width: AppSize.width(value: double.infinity),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSize.width(value: 12)),
                      bottomRight: Radius.circular(AppSize.width(value: 12)),
                    ),
                    color: const Color(0xFFD7F4DE),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.width(value: 28),
                      vertical: AppSize.width(value: 44),
                    ),
                    child: AppButton(
                      borderRadius: BorderRadius.circular(12),
                      title: "Choose Plan",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SubWidGetRow extends StatelessWidget {
  final String? text;
  const SubWidGetRow({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSize.width(value: 24),
      children: [
        const Icon(Icons.check, color: Colors.green),
        AppText(
          data: text ?? "No Text",
          fontSize: AppSize.width(value: 16),
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ],
    );
  }
}
