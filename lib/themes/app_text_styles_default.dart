import 'package:flutter/material.dart';
import 'package:lucro_simples/themes/app_text_styles_interface.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class AppTextStylesDefault extends IAppTextStyles {
  @override
  TextStyle get bodyText => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  @override
  TextStyle get caption => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  @override
  TextStyle get captionMedium => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );

  @override
  TextStyle get h1 => const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  @override
  TextStyle get h2 => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        height: 1.25,
      );

  @override
  TextStyle get h3 => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  @override
  TextStyle get titleSmall => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  @override
  TextStyle get titleMedium => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  @override
  TextStyle get subtitleMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  @override
  TextStyle get appBar => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.25,
        color: AppTheme.colors.content,
      );
}
