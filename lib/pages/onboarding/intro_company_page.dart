import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/entities/company.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:lucro_simples/utils/input_decorations.dart';

class IntroCompanyPage extends StatelessWidget {
  const IntroCompanyPage({
    super.key,
    required this.selectPhoto,
    required this.company,
    required this.formKey,
    required this.nameController,
    required this.userNameController,
  });

  final VoidCallback selectPhoto;
  final Company company;
  final Key formKey;
  final TextEditingController nameController;
  final TextEditingController userNameController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FadeIn(
            child: Image.asset(AppAssets.imgBgOnboarding2),
          ),
          FadeInUp(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KeyboardVisibilityBuilder(
                    builder: (p0, isKeyboardVisible) => TextButton(
                      onPressed: selectPhoto,
                      style: TextButton.styleFrom(
                        maximumSize: Size(
                          isKeyboardVisible ? 120 : 232,
                          isKeyboardVisible ? 120 : 232,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(300),
                        ),
                        backgroundColor: Colors.grey.shade100,
                        padding: EdgeInsets.zero,
                      ),
                      child: ClipOval(
                        child: company.photoURL != null
                            ? Image.file(
                                File(company.photoURL!),
                                fit: BoxFit.cover,
                                width: 294,
                                height: 294,
                              )
                            : Image.asset(
                                AppAssets.imgOnboarding2,
                              ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: selectPhoto,
                    child: Text(
                      'Toque aqui ou na imagem para selecionar uma foto.',
                      style: AppTheme.textStyles.caption,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sobre você',
                    style: AppTheme.textStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: defaultFormDecoration(context).copyWith(
                            labelText: 'Nome da Empresa',
                            fillColor: AppTheme.colors.background,
                            filled: true,
                          ),
                          validator: (v) => v?.trim().isEmpty == true
                              ? 'Por favor, informe o nome da sua empresa.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: userNameController,
                          decoration: defaultFormDecoration(context).copyWith(
                            labelText: 'Seu Nome',
                          ),
                          validator: (v) => v?.trim().isEmpty == true
                              ? 'Por favor, informe o seu nome.'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
