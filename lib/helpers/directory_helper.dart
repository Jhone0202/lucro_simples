import 'dart:io';
import 'package:lucro_simples/app_mode.dart';
import 'package:path_provider/path_provider.dart';

class DirectoryHelper {
  static Future<Directory> getDatabaseDirectory() async {
    if (AppMode.appmode == APP_MODE.runTest) {
      return Directory.current;
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  static Future<Directory> getTempPath() async {
    return await getTemporaryDirectory();
  }
}
