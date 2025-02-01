import 'package:flutter/material.dart';
import 'package:lucro_simples/app_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucro Simples',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themes.lightThemeData(context),
      routes: appRoutes,
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const <Locale>[Locale('pt', 'BR')],
    );
  }
}
