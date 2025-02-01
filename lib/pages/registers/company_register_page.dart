import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucro_simples/app_assets.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/entities/company.dart';
import 'package:lucro_simples/helpers/directory_helper.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/home/home_page.dart';
import 'package:lucro_simples/repositories/company_repository_interface.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:lucro_simples/utils/input_decorations.dart';

class CompanyRegisterPage extends StatefulWidget {
  static const String routeName = 'company_register_page';
  const CompanyRegisterPage({super.key});

  @override
  State<CompanyRegisterPage> createState() => _CompanyRegisterPageState();
}

class _CompanyRegisterPageState extends State<CompanyRegisterPage> {
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final userNameController = TextEditingController();
  Company company = SessionManager.loggedCompany!;
  final repository = getIt.get<ICompanyRepository>();

  @override
  initState() {
    super.initState();
    nameController.text = company.name;
    userNameController.text = company.userName;
  }

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

  Future _saveAndUpdateSession() async {
    company.name = nameController.text;
    company.userName = userNameController.text;

    final saved = await repository.saveCompany(company);
    SessionManager.initSession(saved);

    company = saved;

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.routeName,
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Center(
            child: TextButton(
              onPressed: _selectPhoto,
              style: TextButton.styleFrom(
                maximumSize: Size(232, 232),
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
            onPressed: _selectPhoto,
            child: Text(
              'Toque aqui ou na imagem para selecionar uma foto.',
              style: AppTheme.textStyles.caption,
            ),
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
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: _saveAndUpdateSession,
            title: 'Salvar',
            formKey: formKey,
          ),
        ],
      ),
    );
  }
}
