import 'package:flutter/material.dart';

abstract class IAppThemeData {
  ThemeData lightThemeData(BuildContext context);
  ThemeData darkThemeData(BuildContext context);
}
