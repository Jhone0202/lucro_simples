import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = 'settings_page';
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
    );
  }
}
