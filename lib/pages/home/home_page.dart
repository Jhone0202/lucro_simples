import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/components/secondary_button.dart';
import 'package:lucro_simples/pages/changelog/changelog_page.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showChangeLogDialog();
    });
  }

  void animateToPage(int page) {
    pageController.animateToPage(
      page,
      duration: Durations.medium2,
      curve: Curves.ease,
    );
  }

  void showChangeLogDialog() {
    showDialog(
      context: context,
      builder: (context) => FadeInUp(
        curve: Curves.easeInSine,
        child: AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 160,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 240, 244, 197),
                      Color.fromARGB(255, 220, 243, 190),
                    ],
                  ),
                ),
                child: SvgPicture.asset(
                  AppAssets.imgChangelog,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '🎉 Novidades para você!',
                style: AppTheme.textStyles.titleMedium
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Confira os novos recursos e melhorias que preparamos para você nesta atualização.',
                  textAlign: TextAlign.center,
                  style: AppTheme.textStyles.subtitleMedium.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  ChangelogPage.routeName,
                ),
                title: 'Conhecer Novidades',
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              const SizedBox(height: 8),
              SecondaryButton(
                onPressed: () => Navigator.pop(context),
                title: 'Ver Depois',
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
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
