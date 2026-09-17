import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppImageCircular extends StatelessWidget {
  const AppImageCircular({
    super.key,
    this.color = Colors.blue,
    this.fit = BoxFit.cover,
    this.height,
    this.path,
    this.url,
    this.width,
    this.filePath,
    this.borderRadius = 100,
  });
  final String? path;
  final String? filePath;
  final String? url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    log('=== APP IMAGE CIRCULAR ===');
    log('filePath: $filePath');
    log('url: $url');
    log('path: $path');

    // >>>>>>>>>>>>>>>>>>>>>> Check for file image first <<<<<<<<<<<<<<<<<<<<
    if (filePath != null) {
      log('Loading FILE image: $filePath');
      // If file path is provided, check if the file exists
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.file(
          File(filePath!),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            log("❌ Error loading file image: $error");
            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                width: width,
                height: height,
                color: Colors.pinkAccent,
              ),
            );
          },
        ),
      );
    }

    // >>>>>>>>>>>>>>>>>>>>>> Check for network image (URL) <<<<<<<<<<<<<<<<<<<<
    if (url != null && url!.isNotEmpty) {
      log('URL is not null and not empty: $url');
      String imageUrl = url!;
      if (!(imageUrl.startsWith("http://") ||
          imageUrl.startsWith("https://"))) {
        imageUrl = "https://$imageUrl"; // Add 'https' if not present
        log('URL modified to: $imageUrl');
      }

      log('✅ Loading NETWORK image: $imageUrl');

      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            log("❌ Error loading network image: $error");
            log("❌ Failed URL: $imageUrl");
            log("❌ Stack trace: $stackTrace");
            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                width: width,
                height: height,
                color: Colors.pinkAccent,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              log('✅ Network image loaded successfully');
              return child;
            }
            log(
              '⏳ Loading network image... ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes ?? "unknown"}',
            );
            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                width: width,
                height: height,
                color: Colors.pinkAccent,
                child: const CupertinoActivityIndicator(color: Colors.black),
              ),
            );
          },
        ),
      );
    }

    // >>>>>>>>>>>>>>>>>>>>>> Check for local asset image <<<<<<<<<<<<<<<<<<<<
    if (path != null) {
      log('Loading ASSET image: $path');
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          path!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            log("❌ Error loading asset image: $error");
            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                width: width,
                height: height,
                color: Colors.pinkAccent,
              ),
            );
          },
        ),
      );
    }

    // >>>>>>>>>>>>>>>>>>>>>> Default widget when no image source is provided <<<<<<<<<<<<<<<<<<<<
    log('⚠️ No image source provided, showing default container');
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(width: width, height: height, color: color),
    );
  }
}
