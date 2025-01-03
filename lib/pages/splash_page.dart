import 'package:flutter/material.dart';
import 'package:lucro_simples/pages/home_page.dart';
import 'package:lucro_simples/pages/onboarding/intro_page.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final bool _introFinished = false;

  @override
  void initState() {
    super.initState();
    _firstLoad();
  }

  void _firstLoad() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      _introFinished ? HomePage.routeName : IntroPage.routeName,
      (route) => false,
    );
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
