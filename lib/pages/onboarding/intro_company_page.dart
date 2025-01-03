import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucro_simples/entities/company.dart';
import 'package:lucro_simples/utils/input_decorations.dart';
import 'package:path_provider/path_provider.dart';

class IntroCompanyPage extends StatefulWidget {
  static const String routeName = '/intro_company_page';
  const IntroCompanyPage({super.key});

  @override
  State<IntroCompanyPage> createState() => _IntroCompanyPageState();
}

class _IntroCompanyPageState extends State<IntroCompanyPage> {
  final _company = Company(name: '', userName: '');
  final _picker = ImagePicker();

  Future _selectPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _company.photoURL = savedImage.path; // Salva o caminho da imagem
      });
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
              child: _company.photoURL != null
                  ? ClipOval(
                      child: Image.file(
                        File(_company.photoURL!),
                        fit: BoxFit.cover,
                        width: 160,
                        height: 160,
                      ),
                    )
                  : const Icon(
                      Icons.photo,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(height: 24),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: defaultFormDecoration(context).copyWith(
                      labelText: 'Nome da Empresa',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: defaultFormDecoration(context).copyWith(
                      labelText: 'Seu Nome',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => Navigator.pushNamed(
                context,
                IntroCompanyPage.routeName,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Continuar'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
