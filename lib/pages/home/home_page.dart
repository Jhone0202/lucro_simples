import 'package:flutter/material.dart';
import 'package:lucro_simples/pages/home/customers_page.dart';
import 'package:lucro_simples/pages/home/dashboard_page.dart';
import 'package:lucro_simples/pages/home/products_page.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:lucro_simples/utils/keep_alive_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home_page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          onPageChanged: (page) {
            currentIndex = page;
            setState(() {});
          },
          children: const [
            KeepAlivePage(child: DashboardPage()),
            KeepAlivePage(child: ProductsPage()),
            KeepAlivePage(child: CustomersPage()),
          ],
        ),
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
        unselectedItemColor: AppTheme.colors.secondary,
        items: const [
          BottomNavigationBarItem(
            label: 'Início',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Produtos',
            icon: Icon(Icons.archive),
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
