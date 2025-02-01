import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:lucro_simples/themes/app_theme_data_interface.dart';

class AppThemeData extends IAppThemeData {
  @override
  ThemeData darkThemeData(BuildContext context) {
    return ThemeData.dark();
  }

  @override
  ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppTheme.colors.background,
      colorScheme: ColorScheme.light(
        primary: AppTheme.colors.primary,
        secondary: AppTheme.colors.secondary,
      ),
      dividerTheme: DividerThemeData(color: AppTheme.colors.background),
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
        bodyColor: AppTheme.colors.content,
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: AppTheme.textStyles.appBar,
        centerTitle: true,
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: AppTheme.textStyles.appBar.copyWith(
          color: AppTheme.colors.content,
        ),
        contentTextStyle: AppTheme.textStyles.bodyText.copyWith(
          color: AppTheme.colors.content,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
