import 'dart:io';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/customer_types.dart';
import 'package:lucro_simples/repositories/customer_repository_interface.dart';
import 'package:lucro_simples/utils/input_decorations.dart';
import 'package:path_provider/path_provider.dart';

class CustomerRegisterPage extends StatefulWidget {
  static const String routeName = 'customer_register_page';
  const CustomerRegisterPage({super.key});

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  final picker = ImagePicker();

  final repository = getIt.get<ICustomerRepository>();
  final customer = Customer(
    name: '',
    phoneNumber: '',
    type: IndividualCustomer(),
  );
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '+55 (00) 00000-0000');

  Future _selectPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final saved = await File(pickedFile.path).copy('${dir.path}/$fileName');

      customer.photoURL = saved.path;
      setState(() {});
    }
  }

  Future _saveCustomer() async {
    customer.name = nameController.text;
    customer.phoneNumber = phoneController.text;

    final saved = await repository.registerNewCustomer(customer);

    if (mounted) Navigator.pop(context, saved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      Center(
                        child: TextButton(
                          onPressed: _selectPhoto,
                          style: TextButton.styleFrom(
                            fixedSize: const Size(160, 160),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            backgroundColor: Colors.grey.shade100,
                            padding: EdgeInsets.zero,
                          ),
                          child: customer.photoURL != null
                              ? ClipOval(
                                  child: Image.file(
                                    File(customer.photoURL!),
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
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: defaultFormDecoration(context).copyWith(
                          labelText: 'Nome',
                        ),
                        validator: (v) => v?.trim().isEmpty == true
                            ? 'Por favor, informe o nome do cliente.'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.phone,
                        decoration: defaultFormDecoration(context).copyWith(
                          labelText: 'Telefone',
                        ),
                        validator: (v) => v?.trim().isEmpty == true
                            ? 'Por favor, informe o telefone do cliente.'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: customer.type.id,
                        items: CustomerType.getAllTypes().map((e) {
                          return DropdownMenuItem<int>(
                            value: e.id,
                            child: Text(e.description),
                          );
                        }).toList(),
                        onChanged: (id) {
                          if (id != null) {
                            customer.type = CustomerType.fromId(id);
                            setState(() {});
                          }
                        },
                        decoration: defaultFormDecoration(context).copyWith(
                          labelText: 'Tipo de Cliente',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                onPressed: _saveCustomer,
                title: 'Salvar',
                iconData: Icons.save,
                formKey: formKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
