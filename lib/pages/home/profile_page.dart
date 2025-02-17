import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/components/circle_file_image.dart';
import 'package:lucro_simples/components/profile_list_tile.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/changelog/changelog_page.dart';
import 'package:lucro_simples/pages/registers/company_register_page.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final company = SessionManager.loggedCompany!;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleFileImage(
                size: 96,
                filePath: company.photoURL,
              ),
              const SizedBox(height: 4),
              Text(
                company.name,
                style: AppTheme.textStyles.titleMedium,
              ),
              Text(
                company.userName,
                style: AppTheme.textStyles.subtitleMedium.copyWith(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        ProfileListTile(
          onTap: () => Navigator.pushNamed(
            context,
            CompanyRegisterPage.routeName,
          ),
          icon: CupertinoIcons.pencil_circle,
          title: 'Editar Perfil',
          subtitle: 'Deixe tudo do seu jeito',
        ),
        ProfileListTile(
          onTap: () => Navigator.pushNamed(
            context,
            ChangelogPage.routeName,
          ),
          svgIcon: AppAssets.iconStars, // Ícone SVG
          backgroundColor: AppTheme.colors.yellow.withValues(alpha: 0.12),
          title: 'Novidades',
          subtitle: 'Conheça as funcionalidades do app',
        ),
        ProfileListTile(
          onTap: () {},
          icon: CupertinoIcons.calendar,
          title: 'Data para Cálculos',
          subtitle: 'Data do registro',
        ),
        ProfileListTile(
          icon: CupertinoIcons.info_circle,
          title: 'v1.0.1',
          subtitle: 'Versão do Lucro Simples',
        ),
        ProfileListTile(
          onTap: () {},
          icon: CupertinoIcons.square_arrow_right,
          iconColor: AppTheme.colors.red,
          backgroundColor: AppTheme.colors.red.withValues(alpha: 0.1),
          title: 'Sair',
          subtitle: 'Apagar todos os dados e sair',
          showDivider: false,
        ),
      ],
    );
  }
}
