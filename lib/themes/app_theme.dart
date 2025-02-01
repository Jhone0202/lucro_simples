import 'app_colors_interface.dart';
import 'app_colors_light.dart';
import 'app_text_styles_default.dart';
import 'app_text_styles_interface.dart';
import 'app_theme_data.dart';
import 'app_theme_data_interface.dart';

class AppTheme {
  static IAppColors get colors => AppColorsLight();
  static IAppTextStyles get textStyles => AppTextStylesDefault();
  static IAppThemeData get themes => AppThemeData();
}
