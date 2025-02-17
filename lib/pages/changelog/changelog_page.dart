import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/pages/import_contacts/import_contact_page.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class ChangelogPage extends StatelessWidget {
  static const String routeName = 'changelog_page';
  const ChangelogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FadeInUp(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    height: 160,
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.fromLTRB(16, 56, 16, 0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 240, 244, 197),
                          Color.fromARGB(255, 220, 243, 190),
                        ],
                      ),
                    ),
                    child: Transform.translate(
                      offset: Offset(0, 4),
                      child: SvgPicture.asset(
                        AppAssets.imgContacts,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.colors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppAssets.iconStars,
                          width: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Novidade!',
                          style: AppTheme.textStyles.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Importação de Contatos',
                      style: AppTheme.textStyles.h3,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Agora você pode escolher os contatos que deseja adicionar como clientes no aplicativo. Fácil, rápido e integrado!',
                      style: AppTheme.textStyles.bodyText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 300,
                    height: 500,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.colors.stroke),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(
                      AppAssets.tutorialContactsGif,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    title: 'Testar Agora',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      ImportContactPage.routeName,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SafeArea(
            child: BackButton(),
          ),
        ],
      ),
    );
  }
}
