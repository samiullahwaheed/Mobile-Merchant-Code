
import 'package:get_storage/get_storage.dart';
import 'package:merchent/service/storage/storage_key.dart';
import 'package:merchent/widget/app_log/error_log.dart';

class GetStorageServices {
  GetStorageServices._privateConstructor();
  static final GetStorageServices _instance =
      GetStorageServices._privateConstructor();
  static GetStorageServices get instance => _instance;

  ////////////// storage initial
  GetStorage box = GetStorage();

  ////////////////  token
  Future<void> setToken(String value) async {
    try {
      await box.write(LocalStorageKeys.token, value);
      await box.save();
    } catch (e) {
      errorLog("set token ", e);
    }
  }

  
  Future<void> isUserFirstTime(bool isFirst) async {
    try {
      await box.write(LocalStorageKeys.isUserFirstTime, isFirst);
      await box.save();
    } catch (e) {
      errorLog("set is user first time", e);
    }
  }

  bool? getIsUserFirstTime() {
    try {
      return box.read(LocalStorageKeys.isUserFirstTime);
    } catch (e) {
      errorLog("get is user first time", e);
      return null;
    }
  }
}
