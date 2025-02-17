import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInfoService {
  static final AppInfoService _instance = AppInfoService._internal();
  factory AppInfoService() => _instance;

  AppInfoService._internal();

  late String version;

  late bool shouldShowChangelog;

  final List<String> versionsWithChangelog = ['1.0.1'];

  Future loadAppInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();

    version = packageInfo.version;

    final lastSeenVersion = prefs.getString('lastSeenVersion');

    shouldShowChangelog = versionsWithChangelog.contains(version) &&
        (lastSeenVersion == null || _isNewerVersion(version, lastSeenVersion));
  }

  Future markChangelogAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSeenVersion', version);
    shouldShowChangelog = false;
  }

  bool _isNewerVersion(String current, String last) {
    final currentParts = current.split('.').map(int.parse).toList();
    final lastParts = last.split('.').map(int.parse).toList();

    for (int i = 0; i < currentParts.length; i++) {
      if (currentParts[i] > lastParts[i]) return true;
      if (currentParts[i] < lastParts[i]) return false;
    }
    return false;
  }
}
