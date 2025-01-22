import 'package:flutter/material.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/components/rounded_button.dart';
import 'package:lucro_simples/pages/onboarding/intro_company_page.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class IntroPage extends StatefulWidget {
  static const String routeName = '/intro_page';
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(AppAssets.imgBgOnboardingFirst),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.imgOnboardingFirst,
                  height: 294,
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.colors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.colors.stroke,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.colors.stroke,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                RoundedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    IntroCompanyPage.routeName,
                  ),
                  title: 'Começar',
                  iconData: Icons.arrow_forward,
                  expanded: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
