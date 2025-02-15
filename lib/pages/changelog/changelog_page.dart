import 'package:flutter/material.dart';

class ChangelogPage extends StatelessWidget {
  static const String routeName = 'changelog_page';
  const ChangelogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novidades'),
      ),
    );
  }
}
