import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  static const key = "optimizedCache";

  static final CustomCacheManager instance = CustomCacheManager._();

  CustomCacheManager._()
      : super(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 300,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

String optimizedImageUrl(String url, {int width = 600, int height = 600}) {
  return "$url?width=$width&height=$height";
}