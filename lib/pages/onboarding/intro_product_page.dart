import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class IntroProductPage extends StatelessWidget {
  const IntroProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FadeInLeft(
          child: Image.asset(AppAssets.imgBgOnboarding1),
        ),
        FadeInUp(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: const BoxConstraints(maxHeight: 223),
                  child: Image.asset(
                    AppAssets.imgOnboarding3,
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Registre suas vendas em',
                  style: AppTheme.textStyles.h2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Apenas 5 toques',
                  style: AppTheme.textStyles.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'Para começar, cadastre seu primeiro produto.',
                  style: AppTheme.textStyles.bodyText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
