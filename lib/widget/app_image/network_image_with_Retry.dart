import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../constant/app_api_end_point.dart';
import '../../constant/app_color/assets_icons_path.dart';
import '../../utils/app_log/error_log.dart';
import 'custom_cache_manager.dart';

class NetworkImageWithRetry extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const NetworkImageWithRetry({
    super.key,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
  });

  @override
  State<NetworkImageWithRetry> createState() => _NetworkImageWithRetryState();
}

class _NetworkImageWithRetryState extends State<NetworkImageWithRetry>
    with AutomaticKeepAliveClientMixin {
  int retryCount = 0;
  final int maxRetries = 3; // Limit retries to avoid infinite loop
  late String _image;

  @override
  void initState() {
    super.initState();
    _setImage();
  }

  void _setImage() {
    try {
      // mediaUrl() khud check kar leta hai ke path absolute URL hai ya relative,
      // is liye yahan alag se Uri parse karne ki zaroorat nahi.
      _image = AppApiEndPoint.mediaUrl(widget.imageUrl);
    } catch (e) {
      log("Error setting image URL: $e");
      _image = widget.imageUrl; // Use the raw URL if parsing fails
    }
  }

  void _retry() async {
    try {
      if (retryCount < maxRetries) {
        await Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            setState(() {
              retryCount++;
            });
          }
        });
      } else {
        log("Max retries reached for image: $_image");
      }
    } catch (e) {
      errorLog("_retry $e", );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CachedNetworkImage(
      cacheManager: CustomCacheManager.instance,
      imageUrl: optimizedImageUrl(_image),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      fadeInDuration: const Duration(milliseconds: 100),
      fadeOutDuration: const Duration(milliseconds: 100),
      useOldImageOnUrlChange: true,
      placeholder: (context, url) => _loadingPlaceholder(),
      errorWidget: (context, url, error) {
        _retry();
        return _errorPlaceholder();
      },
    );
  }

  Widget _loadingPlaceholder() {
    return Skeletonizer(
      enabled: true,
      containersColor: Colors.pinkAccent,
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height,
        color: Colors.white,
        child: Image.asset(AssetsPath.placeHolder, fit: BoxFit.fill),
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.pinkAccent,
      child: Center(
        child: Icon(Icons.image_not_supported, color: Colors.pinkAccent),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}