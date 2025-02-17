import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/repositories/product_repository_interface.dart';
import 'package:lucro_simples/utils/input_decorations.dart';
import 'package:lucro_simples/utils/masks.dart';
import 'package:path_provider/path_provider.dart';

class ProductRegisterPage extends StatefulWidget {
  static const String routeName = 'product_register_page';
  const ProductRegisterPage({super.key, this.editableProduct});

  final Product? editableProduct;

  @override
  State<ProductRegisterPage> createState() => _ProductRegisterPageState();
}

class _ProductRegisterPageState extends State<ProductRegisterPage> {
  final picker = ImagePicker();

  final repository = getIt.get<IProductRepository>();
  Product product = Product(name: '', costPrice: 0, salePrice: 0);
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final costPriceController = moneyMaskedTextController();
  final salePriceController = moneyMaskedTextController();

  @override
  void initState() {
    super.initState();
    if (widget.editableProduct != null) {
      _prepareToEdit(widget.editableProduct!);
    }
  }

  void _prepareToEdit(Product editableProduct) {
    product = editableProduct;
    nameController.text = product.name;
    costPriceController.updateValue(product.costPrice);
    salePriceController.updateValue(product.salePrice);
    setState(() {});
  }

  Future _selectPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final saved = await File(pickedFile.path).copy('${dir.path}/$fileName');

      product.photoURL = saved.path;
      setState(() {});
    }
  }

  Future _saveProduct() async {
    product.name = nameController.text;
    product.costPrice = costPriceController.numberValue;
    product.salePrice = salePriceController.numberValue;

    late Product saved;

    if (widget.editableProduct != null) {
      saved = await repository.updateProduct(product);
    } else {
      saved = await repository.registerNewProduct(product);
    }

    if (mounted) Navigator.pop(context, saved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editableProduct != null
              ? 'Editar Produto'
              : 'Cadastrar Produto',
        ),
      ),
      backgroundColor: Colors.white,
      body: FadeInRight(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        AspectRatio(
                          aspectRatio: 1.4,
                          child: InkWell(
                            onTap: _selectPhoto,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey.shade100,
                              ),
                              child: product.photoURL != null
                                  ? Image.file(
                                      File(product.photoURL!),
                                      fit: BoxFit.cover,
                                      width: double.maxFinite,
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey,
                                    ),
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
                              ? 'Por favor, informe o nome do produto.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: costPriceController,
                          keyboardType: TextInputType.number,
                          decoration: defaultFormDecoration(context).copyWith(
                            labelText: 'Preço de Custo',
                          ),
                          validator: (v) => v?.trim().isEmpty == true
                              ? 'Por favor, informe o preço de custo.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: salePriceController,
                          keyboardType: TextInputType.number,
                          decoration: defaultFormDecoration(context).copyWith(
                            labelText: 'Preço de Venda',
                          ),
                          validator: (v) => v?.trim().isEmpty == true
                              ? 'Por favor, informe o preço de venda.'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                PrimaryButton(
                  onPressed: _saveProduct,
                  title: 'Salvar',
                  iconData: Icons.save,
                  formKey: formKey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
