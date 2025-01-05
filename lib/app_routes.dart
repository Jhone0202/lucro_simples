import 'package:flutter/material.dart';
import 'package:lucro_simples/pages/home/home_page.dart';
import 'package:lucro_simples/pages/onboarding/intro_company_page.dart';
import 'package:lucro_simples/pages/onboarding/intro_page.dart';
import 'package:lucro_simples/pages/splash_page.dart';

final appRoutes = <String, WidgetBuilder>{
  SplashPage.routeName: (context) => const SplashPage(),
  IntroPage.routeName: (context) => const IntroPage(),
  IntroCompanyPage.routeName: (context) => const IntroCompanyPage(),
  HomePage.routeName: (context) => const HomePage(),
};
