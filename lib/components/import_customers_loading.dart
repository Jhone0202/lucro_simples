import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class ImportCustomersLoading extends StatelessWidget {
  const ImportCustomersLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, 48),
            child: Lottie.asset(
              AppAssets.loadingTiles,
              width: 240,
            ),
          ),
          Text(
            'Carregando seus Contatos',
            style: AppTheme.textStyles.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'O tempo de carregamento pode variar conforme a quantidade de contatos. Por favor, aguarde.',
              style: AppTheme.textStyles.subtitleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 160),
        ],
      ),
    );
  }
}
