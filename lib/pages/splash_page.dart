import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/home_page.dart';
import 'package:lucro_simples/pages/onboarding/intro_page.dart';
import 'package:lucro_simples/repositories/company_repository_interface.dart';

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
  }

  Future _firstLoad() async {
    final savedCompany = await repository.getSavedCompany();

    if (savedCompany != null) SessionManager.initSession(savedCompany);

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        savedCompany != null ? HomePage.routeName : IntroPage.routeName,
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
