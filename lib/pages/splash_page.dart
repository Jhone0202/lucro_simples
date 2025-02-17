import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/home/home_page.dart';
import 'package:lucro_simples/pages/onboarding/onboarding_page.dart';
import 'package:lucro_simples/repositories/company_repository_interface.dart';
import 'package:lucro_simples/services/app_info_service.dart';
import 'package:lucro_simples/services/config_service.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = '/';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final repository = getIt.get<ICompanyRepository>();

  @override
  void initState() {
    super.initState();
    _firstLoad();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  Future _firstLoad() async {
    await getIt.get<AppInfoService>().loadAppInfo();

    await getIt.get<ConfigService>().loadConfigs();

    final savedCompany = await repository.getSavedCompany();

    if (savedCompany != null) SessionManager.initSession(savedCompany);

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        savedCompany != null ? HomePage.routeName : OnboardingPage.routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 1),
        ),
      ),
    );
  }
}
