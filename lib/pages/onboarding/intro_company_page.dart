import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/rounded_button.dart';
import 'package:lucro_simples/entities/company.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/home_page.dart';
import 'package:lucro_simples/repositories/company_repository_interface.dart';
import 'package:lucro_simples/utils/input_decorations.dart';
import 'package:path_provider/path_provider.dart';

class IntroCompanyPage extends StatefulWidget {
  static const String routeName = '/intro_company_page';
  const IntroCompanyPage({super.key});

  @override
  State<IntroCompanyPage> createState() => _IntroCompanyPageState();
}

class _IntroCompanyPageState extends State<IntroCompanyPage> {
  final picker = ImagePicker();

  final repository = getIt.get<ICompanyRepository>();
  final company = Company(name: '', userName: '');
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final userNameController = TextEditingController();

  Future _selectPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final saved = await File(pickedFile.path).copy('${dir.path}/$fileName');

      company.photoURL = saved.path;
      setState(() {});
    }
  }

  Future _saveAndInitSession() async {
    company.name = nameController.text;
    company.userName = userNameController.text;

    final saved = await repository.registerNewCompany(company);
    SessionManager.initSession(saved);

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Vamos começar cadastrando a sua empresa.',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: _selectPhoto,
              style: TextButton.styleFrom(
                fixedSize: const Size(160, 160),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                ),
                backgroundColor: Colors.grey.shade100,
                padding: EdgeInsets.zero,
              ),
              child: company.photoURL != null
                  ? ClipOval(
                      child: Image.file(
                        File(company.photoURL!),
                        fit: BoxFit.cover,
                        width: 160,
                        height: 160,
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
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
            const SizedBox(height: 32),
            RoundedButton(
              onPressed: _saveAndInitSession,
              title: 'Salvar',
              iconData: Icons.arrow_forward,
              expanded: false,
              formKey: formKey,
            ),
          ],
        ),
      ),
    );
  }
}
