import 'package:flutter/material.dart';
import 'package:lucro_simples/components/rounded_button.dart';
import 'package:lucro_simples/pages/onboarding/intro_company_page.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo ao Lucro Simples',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              'Aqui você poderá acompanhar suas vendas, lucros, períodos com mais vendas, entre outros.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
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
    );
  }
}
