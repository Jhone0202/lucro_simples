import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';

abstract class FeedbackUser {
  static void toast({required String msg}) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
  }

  static void vibrate() {
    Future.microtask(() async {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(pattern: [0, 100, 50, 100]);
      }
    });
  }
}
