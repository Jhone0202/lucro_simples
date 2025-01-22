import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppTheme.colors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.colors.primary,
          primary: AppTheme.colors.primary,
        ),
        dividerTheme: DividerThemeData(
          color: AppTheme.colors.stroke,
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: AppTheme.colors.content),
      ),
      routes: appRoutes,
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const <Locale>[Locale('pt', 'BR')],
    );
  }
}
