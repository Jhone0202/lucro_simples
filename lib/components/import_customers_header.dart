import 'package:flutter/material.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ImportCustomersHeader extends StatelessWidget {
  const ImportCustomersHeader({super.key, this.onVisibilityChanged});

  final Function(VisibilityInfo)? onVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('importContactsHeader'),
      onVisibilityChanged: onVisibilityChanged,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: kToolbarHeight),
            Image.asset(
              AppAssets.importContacts,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 4),
            Text(
              'Importação de Contatos',
              style: AppTheme.textStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Escolha os contatos que você deseja adicionar como clientes no aplicativo.',
              style: AppTheme.textStyles.subtitleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
