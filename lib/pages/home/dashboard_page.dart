import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucro_simples/managers/session_manager.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final company = SessionManager.loggedCompany!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
            width: 56,
            height: 56,
            child: ClipOval(
              child: company.photoURL != null
                  ? Image.file(
                      File(company.photoURL!),
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
            ),
          ),
          title: Text(company.name),
          subtitle: Text(company.userName),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Nova Venda'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
