import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:lucro_simples/utils/feedback_user.dart';

class SuccessImportPage extends StatelessWidget {
  static const String routeName = 'success_import_page';

  const SuccessImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    FeedbackUser.vibrate();

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: FadeIn(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: 96,
                height: 96,
                child: Lottie.asset(
                  AppAssets.sucessAnim,
                  repeat: false,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Contatos Importados com Sucesso!',
                style: AppTheme.textStyles.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Seus novos clientes já estão disponíveis pra você, aproveite',
                style: AppTheme.textStyles.subtitleMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                onPressed: () => Navigator.pop(context),
                title: 'Ver Clientes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
