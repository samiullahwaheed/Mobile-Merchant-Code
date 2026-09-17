import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import '../../constant/app_color/assets_icons_path.dart';
import 'full_screen_image_viewer.dart';
import 'network_image_with_Retry.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    this.color,
    this.fit = BoxFit.cover,
    this.height,
    this.path,
    this.url,
    this.width,
    this.filePath,
    this.iconColor,
    this.isZomBle = false,
    this.placeholder,
    this.networkPlaceholderImage,
  });

  final String? path;
  final String? networkPlaceholderImage;
  final String? filePath;
  final String? url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final double? placeholder;
  final Color? color;
  final Color? iconColor;
  final bool isZomBle;

  @override
  Widget build(BuildContext context) {
    // File image
    if (filePath != null) {
      return GestureDetector(
        onTap: isZomBle
            ? () {
                if (isZomBle) {
                  _showFullScreenImage(
                    context,
                    Image.file(
                      File(filePath!),
                      width: width,
                      height: height,
                      fit: fit,
                      errorBuilder: (context, error, stackTrace) {
                        log("Error loading file image: $error");
                        return _errorPlaceholder();
                      },
                    ),
                  );
                }
              }
            : null,
        child: Image.file(
          File(filePath!),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            log("Error loading file image: $error");
            return _errorPlaceholder();
          },
        ),
      );
    }

    // Network image
    if (url != null && url!.isNotEmpty) {
      return GestureDetector(
        onTap: isZomBle
            ? () {
                if (isZomBle) {
                  _showFullScreenImage(
                    context,
                    NetworkImageWithRetry(
                      key: UniqueKey(),
                      imageUrl: url!,
                      width: width,
                      height: height,
                      fit: fit,
                    ),
                  );
                }
              }
            : null,
        child: NetworkImageWithRetry(
          key: UniqueKey(),
          imageUrl: url!,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    }

    // Asset image
    if (path != null) {
      return GestureDetector(
        onTap: isZomBle
            ? () {
                if (isZomBle) {
                  _showFullScreenImage(
                    context,
                    Image.asset(
                      path!,
                      width: width,
                      height: height,
                      fit: fit,
                      color: iconColor,
                      errorBuilder: (context, error, stackTrace) {
                        log("Error loading asset image: $error");
                        return _errorPlaceholder();
                      },
                    ),
                  );
                }
              }
            : null,
        child: Image.asset(
          path!,
          width: width,
          height: height,
          fit: fit,
          color: iconColor,
          errorBuilder: (context, error, stackTrace) {
            log("Error loading asset image: $error");
            return _errorPlaceholder();
          },
        ),
      );
    }

    // Default placeholder
    return Container(
      width: width,
      height: height,
      color: color ?? Colors.white,
      child: Image.asset(
        networkPlaceholderImage ?? AssetsPath.placeHolder,
        width: width,
        height: height,
        fit: fit,
        color: iconColor,
        errorBuilder: (context, error, stackTrace) {
          log("Error loading asset image: $error");
          return _errorPlaceholder();
        },
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: color,
      child: const Center(child: Icon(Icons.image_not_supported)),
    );
  }

  void _showFullScreenImage(BuildContext context, Widget imageWidget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(image: imageWidget),
      ),
    );
  }
}
