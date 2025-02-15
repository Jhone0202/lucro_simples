import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

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
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: Image.asset(
                    AppAssets.imgOnboarding1,
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Bem-vindo ao',
                  style: AppTheme.textStyles.h2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Lucro Simples',
                  style: AppTheme.textStyles.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'O app perfeito para você, pequeno empreendedor, gerenciar suas vendas e acompanhar seus lucros de forma prática!',
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
