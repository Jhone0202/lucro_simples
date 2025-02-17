import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/pages/home/customers_page.dart';
import 'package:lucro_simples/pages/home/dashboard_page.dart';
import 'package:lucro_simples/pages/home/products_page.dart';
import 'package:lucro_simples/pages/home/profile_page.dart';
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

  void animateToPage(int page) {
    pageController.animateToPage(
      page,
      duration: Durations.medium2,
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: pageController,
          onPageChanged: (page) {
            currentIndex = page;
            setState(() {});
          },
          children: [
            KeepAlivePage(
              child: DashboardPage(
                goToProfile: () => animateToPage(4),
              ),
            ),
            const KeepAlivePage(child: ProductsPage()),
            const KeepAlivePage(child: CustomersPage()),
            const KeepAlivePage(child: ProfilePage()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: animateToPage,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: AppTheme.colors.secondary,
        iconSize: 20,
        items: const [
          BottomNavigationBarItem(
            label: 'Início',
            icon: Icon(CupertinoIcons.home),
          ),
          BottomNavigationBarItem(
            label: 'Produtos',
            icon: Icon(CupertinoIcons.cube_box),
          ),
          BottomNavigationBarItem(
            label: 'Clientes',
            icon: Icon(CupertinoIcons.person_2),
          ),
          BottomNavigationBarItem(
            label: 'Perfil',
            icon: Icon(CupertinoIcons.profile_circled),
          ),
        ],
      ),
    );
  }
}
