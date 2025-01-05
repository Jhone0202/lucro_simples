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
  final pageController = PageController();
  int currentIndex = 0;

  final company = SessionManager.loggedCompany!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (page) {
          currentIndex = page;
          setState(() {});
        },
        children: [
          Scaffold(
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
          ),
          Container(),
          Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (page) {
          pageController.animateToPage(
            page,
            duration: Durations.medium2,
            curve: Curves.ease,
          );
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Início',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Produtos',
            icon: Icon(Icons.local_offer),
          ),
          BottomNavigationBarItem(
            label: 'Clientes',
            icon: Icon(Icons.people),
          ),
        ],
      ),
    );
  }
}
