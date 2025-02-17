import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/app_notifiers.dart';
import 'package:lucro_simples/components/circle_file_image.dart';
import 'package:lucro_simples/components/profile_list_tile.dart';
import 'package:lucro_simples/databases/ls_database.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/changelog/changelog_page.dart';
import 'package:lucro_simples/pages/registers/company_register_page.dart';
import 'package:lucro_simples/pages/splash_page.dart';
import 'package:lucro_simples/services/app_info_service.dart';
import 'package:lucro_simples/services/config_service.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final company = SessionManager.loggedCompany!;
  final config = getIt.get<ConfigService>();
  final appInfoService = getIt.get<AppInfoService>();

  void _showSalesAggregationDialog() {
    showDialog(
      context: context,
      builder: (context) => FadeInUp(
        curve: Curves.easeInSine,
        child: AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 160,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 240, 244, 197),
                      Color.fromARGB(255, 220, 243, 190),
                    ],
                  ),
                ),
                child: SvgPicture.asset(
                  AppAssets.imgDataAnalysis,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Data para Cálculos',
                style: AppTheme.textStyles.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Selecione a data que os gráficos devem considerar para os cálculos',
                textAlign: TextAlign.center,
                style: AppTheme.textStyles.subtitleMedium.copyWith(
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 12),
              RadioListTile<String>(
                value: 'saleDate',
                groupValue: config.salesAggregationDate,
                onChanged: (v) => _onAggregationChanged(v, context),
                title: Text(
                  'Data de registro',
                  style: AppTheme.textStyles.bodyText,
                ),
              ),
              const Divider(),
              RadioListTile<String>(
                value: 'deliveryDate',
                groupValue: config.salesAggregationDate,
                onChanged: (v) => _onAggregationChanged(v, context),
                title: Text(
                  'Data de entrega',
                  style: AppTheme.textStyles.bodyText,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _onAggregationChanged(String? value, BuildContext dialogContext) async {
    if (value != null && value != config.salesAggregationDate) {
      await config.setSalesAggregationDate(value);
      refreshDashboard.value = true;
      setState(() {});
      if (dialogContext.mounted) Navigator.pop(dialogContext);
    }
  }

  Future _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text(
            'Tem certeza que deseja sair? Todos os dados serão apagados.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      config.clearAll();

      await LsDatabase().resetDatabase();

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          SplashPage.routeName,
          (route) => false,
        );
      }
    }
  }

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
          onTap: _showSalesAggregationDialog,
          icon: CupertinoIcons.calendar,
          title: 'Data para Cálculos',
          subtitle: config.salesAggregationDate == 'saleDate'
              ? 'Data de registro'
              : 'Data de entrega',
        ),
        ProfileListTile(
          icon: CupertinoIcons.info_circle,
          title: 'v${appInfoService.version}',
          subtitle: 'Versão do Lucro Simples',
        ),
        ProfileListTile(
          onTap: _logout,
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
