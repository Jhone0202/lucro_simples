import 'package:flutter/material.dart';
import 'package:lucro_simples/pages/home/customers_page.dart';
import 'package:lucro_simples/pages/home/dashboard_page.dart';
import 'package:lucro_simples/pages/home/products_page.dart';

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
      body: PageView(
        controller: pageController,
        onPageChanged: (page) {
          currentIndex = page;
          setState(() {});
        },
        children: const [
          DashboardPage(),
          ProductsPage(),
          CustomersPage(),
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
