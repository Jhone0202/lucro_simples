import 'package:fluttertoast/fluttertoast.dart';

abstract class FeedbackUser {
  static void toast({required String msg}) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
  }
}
