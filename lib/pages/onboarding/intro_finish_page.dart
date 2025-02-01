import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class IntroFinishPage extends StatelessWidget {
  const IntroFinishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 320),
              child: Image.asset(
                AppAssets.imgOnboarding4,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'Tudo pronto!',
              style: AppTheme.textStyles.h2,
              textAlign: TextAlign.center,
            ),
            Text(
              'Boas Vendas',
              style: AppTheme.textStyles.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Você já tem tudo que precisa para registrar suas vendas.',
              style: AppTheme.textStyles.bodyText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
