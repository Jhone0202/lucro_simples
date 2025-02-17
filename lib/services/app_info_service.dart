import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  static final AppInfoService _instance = AppInfoService._internal();
  factory AppInfoService() => _instance;

  AppInfoService._internal();

  late String version;

  Future<void> loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }
}
