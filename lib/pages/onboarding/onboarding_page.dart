import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/outlined_rounded_button.dart';
import 'package:lucro_simples/components/page_indicator.dart';
import 'package:lucro_simples/components/rounded_button.dart';
import 'package:lucro_simples/entities/company.dart';
import 'package:lucro_simples/helpers/directory_helper.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/home/home_page.dart';
import 'package:lucro_simples/pages/onboarding/intro_company_page.dart';
import 'package:lucro_simples/pages/onboarding/intro_page.dart';
import 'package:lucro_simples/pages/onboarding/intro_product_page.dart';
import 'package:lucro_simples/repositories/company_repository_interface.dart';
import 'package:lucro_simples/utils/keep_alive_page.dart';

class OnboardingPage extends StatefulWidget {
  static const String routeName = 'onboarding_page';

  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final pageController = PageController();
  int currentIndex = 0;

  // page 1
  void _nextPage() {
    pageController.nextPage(duration: Durations.medium2, curve: Curves.ease);
  }

  // page 2
  final picker = ImagePicker();

  final repository = getIt.get<ICompanyRepository>();
  Company company = Company(name: '', userName: '');
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final userNameController = TextEditingController();

  Future _selectPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final dir = await DirectoryHelper.getDatabaseDirectory();
      final fileName = pickedFile.name;
      final saved = await File(pickedFile.path).copy('${dir.path}/$fileName');

      company.photoURL = saved.path;
      setState(() {});
    }
  }

  Future _saveAndInitSession() async {
    company.name = nameController.text;
    company.userName = userNameController.text;

    final saved = await repository.saveCompany(company);
    SessionManager.initSession(saved);

    company = saved;

    _nextPage();
  }

  void _finish() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      HomePage.routeName,
      (route) => false,
    );
  }

  void _registerProduct() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: KeyboardVisibilityBuilder(
          builder: (p0, isKeyboardVisible) => Column(
            children: [
              Expanded(
                flex: 8,
                child: Stack(
                  children: [
                    PageView(
                      controller: pageController,
                      onPageChanged: (page) {
                        currentIndex = page;
                        setState(() {});
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const KeepAlivePage(child: IntroPage()),
                        KeepAlivePage(
                          child: IntroCompanyPage(
                            company: company,
                            formKey: formKey,
                            nameController: nameController,
                            selectPhoto: _selectPhoto,
                            userNameController: userNameController,
                          ),
                        ),
                        const KeepAlivePage(child: IntroProductPage()),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: Durations.medium2,
                      child: currentIndex > 0
                          ? BackButton(
                              onPressed: () => pageController.previousPage(
                                curve: Curves.ease,
                                duration: Durations.medium1,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: isKeyboardVisible ? 2 : 3,
                child: Column(
                  children: [
                    PageIndicator(
                      currentIndex: currentIndex,
                      padding: isKeyboardVisible
                          ? const EdgeInsets.symmetric(vertical: 16)
                          : null,
                    ),
                    AnimatedSwitcher(
                      duration: Durations.medium1,
                      child: currentIndex == 0
                          ? RoundedButton(
                              onPressed: _nextPage,
                              title: 'Começar',
                              iconData: Icons.arrow_forward,
                              expanded: false,
                            )
                          : currentIndex == 1
                              ? RoundedButton(
                                  onPressed: _saveAndInitSession,
                                  title: 'Continuar',
                                  iconData: Icons.arrow_forward,
                                  expanded: false,
                                  formKey: formKey,
                                )
                              : Column(
                                  children: [
                                    RoundedButton(
                                      onPressed: _registerProduct,
                                      title: 'Cadastrar Produto',
                                      iconData: Icons.arrow_forward,
                                      expanded: false,
                                    ),
                                    const SizedBox(height: 16),
                                    OutlinedRoundedButton(
                                      onPressed: _finish,
                                      title: 'Cadastrar Depois',
                                      iconData: Icons.arrow_forward,
                                      expanded: false,
                                    ),
                                  ],
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
