import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucro_simples/managers/session_manager.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home_page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final company = SessionManager.loggedCompany!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipOval(
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
            title: Text(company.name),
            subtitle: Text(company.userName),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }
}
