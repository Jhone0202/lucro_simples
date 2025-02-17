import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucro_simples/themes/app_colors_interface.dart';

class AppColorsLight extends IAppColors {
  @override
  Color get background => const Color(0xFFF5F5F5);

  @override
  Color get content => const Color(0xFF1E1E1E);

  @override
  Color get primary => const Color(0xFF449247);

  @override
  Color get secondary => const Color(0xFF2D5E2F);

  @override
  Color get stroke => const Color(0xFFD9D9D9);

  @override
  Color get yellow => const Color(0xFFFFC107);

  @override
  Color get red => const Color(0xFFE53935);
}
