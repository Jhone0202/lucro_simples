import 'package:flutter/material.dart';
import 'package:lucro_simples/themes/app_text_styles_interface.dart';

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
  TextStyle get h1 => const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get h2 => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
      );
}
